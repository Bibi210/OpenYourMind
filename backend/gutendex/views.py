import re
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from gutendex.models import Book, Keyword, Suggestions
from gutendex.serializers import BookSerializer, DetailedBookSerializer
from gutendex.helpers import get_requested_page, get_pagefrom_request, get_token, search_token, search_regex, get_page


class TopBooks(APIView):
    def get(self, request):
        top = Book.objects.order_by('-download_count')
        serializer = BookSerializer(get_requested_page(request, top), many=True)
        return Response(serializer.data)


class SearchBook(APIView):
    def get(self, request, sentence):
        page = get_pagefrom_request(request)
        tokens = get_token(sentence)
        result = []
        if not tokens:
            result = search_regex(sentence, page)
        else:
            result = search_token(tokens)
        result = get_page(page, result)
        serializer = BookSerializer(result, many=True)
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
        queryset = Suggestions.objects.get(book_id=book_id).suggested_books.all()
        serializer = BookSerializer(get_requested_page(request, queryset), many=True)
        return Response(serializer.data)
