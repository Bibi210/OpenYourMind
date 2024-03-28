import re
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from gutendex.models import Book, JaccardIndex
from django.db.models import Q
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
        try:
            book = Book.objects.get(pk=book_id)
            queryset = JaccardIndex.objects.filter(Q(book1=book) | Q(book2=book)).order_by('-index')
            result = []
            for suggestion in queryset:
                if suggestion.book1 == book:
                    result.append(suggestion.book2)
                else:
                    result.append(suggestion.book1)

            result = get_requested_page(request, result)
            return Response(BookSerializer(result, many=True).data)
        except Book.DoesNotExist:
            return Response([])
