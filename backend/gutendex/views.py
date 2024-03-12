import nltk
from django.db.models import Q, Avg, Sum
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
import math

from gutendex.models import Book, BookKeyword, JaccardIndex, Keyword
from gutendex.serializers import BookSerializer, DetailedBookSerializer
from functools import partial

nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')

# Create your views here.

page_size = 32
stop_words = set(nltk.corpus.stopwords.words('english'))
stemmer = nltk.stem.SnowballStemmer('english')


def get_requested_page(request, queryset):
    page = request.GET.get('page')
    if page is not None and page.isdigit():
        page = int(page)
        start = (page - 1) * page_size
        end = start + page_size
        return queryset[start:end]
    return queryset[:page_size]


def calculate_score(tokens, book):
    average_tf = 0
    average_idf = 0
    for token in tokens:
        try:
            word = Keyword.objects.get(word=token)
            idf = word.idf
            """ ICI HYPER LONG GENRE 99% du temps de recherche how to fix ? """
            tf = BookKeyword.objects.get(book=book, keyword__word=word).repetition_percentage
            """ ICI HYPER LONG GENRE 99% du temps de recherche how to fix ? """
            average_tf += tf
            average_idf += idf
        except BookKeyword.DoesNotExist:
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
        title_match = self.get_matching_all_tokens(tokens)
        print(f'Queryset count: {len(title_match)}')
        """ If the queryset is empty, we will try to find books that have similar keywords to the ones in the sentence"""
        if len(title_match) == 0:
            title_match = Book.objects.filter(keywords__word__in=tokens)
            titlebooks = Book.objects.all()
            for token in tokens:
                titlebooks |= Book.objects.filter(title__icontains=token)

            partial_apply = partial(calculate_score, tokens)
            sorted_books = sorted(title_match, key=partial_apply, reverse=True)
            sorted_title_books = sorted(titlebooks, key=partial_apply, reverse=True)
            title_match = sorted_title_books + sorted_books
        return title_match

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
        tokens = get_token(book.title)
        """ Get token with the lowest repetition percentage in all books """
        best_token = None
        best_percentage = 100
        for token in tokens:
            average = 0
            for b in Book.objects.all().exclude(pk=book_id):
                contains = BookKeyword.objects.filter(book=b, keyword__word=token).first()
                number = contains.repetition_percentage if contains else 0
                average += number
            average = average / (Book.objects.count() - 1)
            if average < best_percentage:
                best_percentage = average
                best_token = token
        print(f'Best token: {best_token}')
        recherche = SearchBook()
        queryset = recherche.search(tokens=[best_token])
        jaccard_index_map = {}
        for b in queryset:
            index = JaccardIndex.objects.filter(Q(book1=book, book2=b) | Q(book1=b, book2=book)).first()
            jaccard_index_map[b] = index.index if index else 2

        averageindex = sum(jaccard_index_map.values()) / len(jaccard_index_map)
        threshold = averageindex - (averageindex * 0.15)
        queryset = list(filter(lambda b: jaccard_index_map[b] < threshold, queryset))
        serializer = BookSerializer(get_requested_page(request, queryset), many=True)
        return Response(serializer.data)
