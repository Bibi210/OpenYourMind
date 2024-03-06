import nltk
from django.db.models import Prefetch
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from gutendex.serializers import *
from .models import *
from rest_framework.views import APIView


# Create your views here.

class TopBooks(APIView):
    def get(self, request):
        top = Book.objects.order_by('-download_count')[:10]
        serializer = BookSerializer(top, many=True)
        return Response(serializer.data)


class SearchBook(APIView):

    def get(self, request, word):
        try:
            stemmer = nltk.stem.SnowballStemmer('english')
            keyword = Keyword.objects.get(word=stemmer.stem(word.lower()))
            bookkeywords = BookKeyword.objects.filter(keyword=keyword).order_by('-repetition_percentage')
            books = [bk.book for bk in bookkeywords]
            serializer = BookSerializer(books, many=True)
            return Response(serializer.data)

        except Keyword.DoesNotExist:
            return Response({"error": "Keyword not found"}, status=status.HTTP_404_NOT_FOUND)

