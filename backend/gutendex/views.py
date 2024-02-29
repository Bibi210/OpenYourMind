from django.shortcuts import render
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
