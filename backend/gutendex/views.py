import nltk
from django.db.models import Q
from rest_framework import status
from rest_framework.response import Response
from gutendex.serializers import *
from .models import *
from rest_framework.views import APIView

nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')

# Create your views here.

page_size = 32


def getRequestedPage(request, queryset):
    queryset = queryset.distinct()
    page = request.GET.get('page')
    if page is not None and page.isdigit():
        page = int(page)
        start = (page - 1) * page_size
        end = start + page_size
        return queryset[start:end]
    return queryset[:page_size]


class TopBooks(APIView):
    def get(self, request):
        top = Book.objects.order_by('-download_count')[:10]
        serializer = BookSerializer(top, many=True)
        return Response(serializer.data)


class SearchBookOrderedByBetweenness(APIView):
    stop_words = set(nltk.corpus.stopwords.words('english'))
    stemmer = nltk.stem.SnowballStemmer('english')

    def order_by_betweenness(self, queryset):
        return queryset.order_by('-betweenness_centrality')

    def get(self, request, sentence):
        tokens = nltk.word_tokenize(sentence)
        tokens = [self.stemmer.stem(word.lower()) for word in tokens if word.isalpha()
                  and word.lower() not in self.stop_words]
        print(f'Querying for {tokens}')
        queryset = Book.objects.all()
        for token in tokens:
            queryset = queryset.filter(keywords__word=token)
        print(f'Queryset count: {queryset.count()}')
        """ If the queryset is empty, we will try to find books that have similar keywords to the ones in the sentence"""
        if queryset.count() == 0:
            queryset = Book.objects.filter(keywords__word__in=tokens)

        queryset = getRequestedPage(request, self.order_by_betweenness(queryset))
        print(f'SQL Query: {queryset.query}')
        return Response(BookSerializer(queryset, many=True).data)


class GetHighestBetweenness(APIView):
    def get(self, request):
        queryset = Book.objects.all().order_by('-betweenness_centrality')
        queryset = getRequestedPage(request, queryset)
        return Response(BookSerializer(queryset, many=True).data)


class BookDetail(APIView):
    def get(self, request, pk):
        try:
            book = Book.objects.get(pk=pk)
            serializer = DetailedBookSerializer(book)
            return Response(serializer.data)
        except Book.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
