import nltk
import requests
from django.core.management.base import BaseCommand
from gutendex.models import Keyword, Format

nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')

class Command(BaseCommand):
    help = 'Get words from books and create index table for search engine'

    def handle(self, *args, **kwargs):
        self.create_Table()

    def create_Table(self):
        stop_words = set(nltk.corpus.stopwords.words('english'))
        stemmer = nltk.stem.SnowballStemmer('english')

        for format in Format.objects.all():
            if format.format_type in ['text/plain; charset=us-ascii', 'text/plain; charset=utf-8']:
                rawtext = requests.get(format.url).text
                tokens = nltk.word_tokenize(rawtext)
                tokens = [word for word in tokens if word.lower() not in stop_words]
                tokens = [stemmer.stem(word) for word in tokens]
                for keyword in set(tokens):  # Use set to avoid duplicates
                    keyword_obj, created = Keyword.objects.get_or_create(word=keyword)
                    keyword_obj.books.add(format.book)
                    print(f'Added word: {keyword} for book: {format.book.title}')
