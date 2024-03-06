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


class URLSerializer(serializers.ModelSerializer):
    class Meta:
        model = Format
        fields = ['format_type', 'url']

    def to_representation(self, instance):
        if instance.format_type in ['text/plain; charset=us-ascii', 'text/plain; charset=utf-8', 'image/jpeg',
                                    'image/png']:
            return super().to_representation(instance)
        else:
            return {}


class BookSerializer(serializers.ModelSerializer):
    authors = AuthorSerializer(many=True, read_only=True)
    urls = URLSerializer(many=True, read_only=True, source='formats')

    class Meta:
        model = Book
        exclude = ('keywords',)

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['urls'] = [url for url in data['urls'] if url]
        return data


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
