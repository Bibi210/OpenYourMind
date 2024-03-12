import nltk
from django.db.models import Q
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
import requests
from concurrent import futures
import subprocess


from gutendex.models import Book, BookKeyword, JaccardIndex, Keyword
from gutendex.serializers import BookSerializer, DetailedBookSerializer
from functools import partial
from django.core.paginator import Paginator

nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')

# Create your views here.

page_size = 32
stop_words = set(nltk.corpus.stopwords.words('english'))
stemmer = nltk.stem.SnowballStemmer('english')


def get_requested_page(request, queryset):
    page = request.GET.get('page')
    paginator = Paginator(queryset, page_size)
    return paginator.get_page(page)


def calculate_score(tokens, book):
    average_tf = 0
    average_idf = 0
    for token in tokens:
        try:
            word = Keyword.objects.get(word=token)
            idf = word.idf
            tf = BookKeyword.objects.filter(book=book).get(keyword=word).repetition_percentage
            average_tf += tf
            average_idf += idf
        except (BookKeyword.DoesNotExist, Keyword.DoesNotExist):
            pass

    tokenlen = len(tokens)
    average_idf = average_idf / tokenlen
    average_tf = average_tf / tokenlen
    average_tf = 0.7 * average_tf * average_idf
    closeness_score = 0.15 * book.closeness_centrality
    betweenness_score = 0.15 * book.betweenness_centrality
    return average_tf + closeness_score + betweenness_score


def get_token(sentence):
    tokens = nltk.word_tokenize(sentence)
    tokens = [stemmer.stem(word.lower()) for word in tokens if word.isalpha()
              and word.lower() not in stop_words]
    return tokens


class TopBooks(APIView):
    def get(self, request):
        top = Book.objects.order_by('-download_count')
        serializer = BookSerializer(get_requested_page(request, top), many=True)
        return Response(serializer.data)


class SearchBook(APIView):

    def get_matching_all_tokens(_, tokens):
        queryset = Book.objects.all()
        titlebooks = Book.objects.all()
        for token in tokens:
            queryset = queryset.filter(keywords__word=token)
            titlebooks = titlebooks.filter(title__icontains=token)

        partial_apply = partial(calculate_score, tokens)
        titlebooks = titlebooks.exclude(pk__in=[b.pk for b in queryset])
        queryset = sorted(titlebooks, key=partial_apply, reverse=True) + \
            sorted(queryset, key=partial_apply, reverse=True)
        return queryset

    def search(self, tokens):
        print(f'Querying for {tokens}')
        result = self.get_matching_all_tokens(tokens)
        print(f'Queryset count: {len(result)}')
        """ If the queryset is empty, we will try to find books that have similar keywords to the ones in the sentence"""
        if len(result) == 0:
            result = Book.objects.filter(keywords__word__in=tokens)
            query = Q()
            for token in tokens:
                query |= Q(title__icontains=token)
            title_match = Book.objects.filter(query)

            print(f'Queryset count: {len(result)}')
            print(f'Title match count: {title_match.query}')
            partial_apply = partial(calculate_score, tokens)
            sorted_books = sorted(result, key=partial_apply, reverse=True)
            sorted_title_books = sorted(title_match, key=partial_apply, reverse=True)
            result = sorted_title_books + sorted_books
        return result

    def get(self, request, sentence):
        tokens = get_token(sentence)
        print(f'Querying for {tokens}')
        queryset = self.search(tokens)
        queryset = get_requested_page(request, queryset)
        serializer = BookSerializer(queryset, many=True)
        return Response(serializer.data)


class GetHighestBetweenness(APIView):
    def get(self, request):
        queryset = Book.objects.all().order_by('-betweenness_centrality')
        queryset = get_requested_page(request, queryset)
        return Response(BookSerializer(queryset, many=True).data)


class BookDetail(APIView):
    def get(self, _, pk):
        try:
            book = Book.objects.get(pk=pk)
            serializer = DetailedBookSerializer(book)
            return Response(serializer.data)
        except Book.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)


class Suggest(APIView):
    def get(self, request, book_id):
        print(f'Book id: {book_id}')
        book = Book.objects.get(pk=book_id)
        """ Get token with the lowest repetition percentage in all books """
        idf_sorted_tokens = sorted(get_token(book.title), key=lambda token: Keyword.objects.get(
            word=token).idf, reverse=True)[:2]
        print(f'Best tokens: {idf_sorted_tokens}')
        queryset = SearchBook().search(tokens=idf_sorted_tokens)
        queryset.remove(book)
        jaccard_index_map = {}
        for b in queryset:
            index = JaccardIndex.objects.get(Q(book1=book, book2=b) | Q(book1=b, book2=book))
            jaccard_index_map[b] = index.index

        averageindex = sum(jaccard_index_map.values()) / len(jaccard_index_map)
        queryset = list(filter(lambda b: jaccard_index_map[b] < averageindex, queryset))
        serializer = BookSerializer(get_requested_page(request, queryset), many=True)
        return Response(serializer.data)


class RegExSearch(APIView):

    def check_book(self, book, regex, format_type):
        url = book.formats.get(format_type=format_type).url
        rawtext = requests.get(url).text
        try:
            subprocess.run(['egrep', '-q', regex, '-'], input=rawtext.encode(),
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            print(f'Book {book.title} MATCH')
        except subprocess.CalledProcessError:
            print(f'Book {book.title} NO')
            return None
        return book

    def get(self, request, regex):
        eligible_books = Book.objects.filter(formats__format_type__in=['text/plain; charset=us-ascii']).distinct()
        """ Create Batch of 10 books """
        batch = []
        matchs = []
        check = partial(self.check_book, regex=regex, format_type='text/plain; charset=us-ascii')
        executor = futures.ThreadPoolExecutor()
        requested_page = request.GET.get('page')
        if requested_page is None:
            requested_page = 1
        else:
            requested_page = int(requested_page)
        print(f'Requested page: {requested_page}')
        for book in eligible_books:
            batch.append(book)
            if len(batch) == page_size + (page_size * 0.5):
                matchs += list(filter(lambda b: b is not None, executor.map(check, batch)))
                batch = []
            if len(matchs) > page_size * requested_page:
                break
        output = get_requested_page(request, matchs)
        serializer = BookSerializer(output, many=True)
        return Response(serializer.data)
