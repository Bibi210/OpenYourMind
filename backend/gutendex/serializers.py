from rest_framework import serializers
from .models import *


class AuthorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Author
        fields = '__all__'


class KeywordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Keyword
        fields = '__all__'


class BookSerializer(serializers.ModelSerializer):
    authors = AuthorSerializer(many=True, read_only=True)
    keywords = KeywordSerializer(many=True, read_only=True)

    class Meta:
        model = Book
        fields = '__all__'


class BookKeywordSerializer(serializers.ModelSerializer):
    book = BookSerializer(read_only=True)
    keyword = KeywordSerializer(read_only=True)

    class Meta:
        model = BookKeyword
        fields = '__all__'


class FormatSerializer(serializers.ModelSerializer):
    book = BookSerializer(read_only=True)

    class Meta:
        model = Format
        fields = '__all__'
