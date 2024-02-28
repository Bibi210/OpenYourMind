import nltk
import requests
from django.core.management.base import BaseCommand
import requests
from gutendex.models import Keyword, Format


stop_words = set(nltk.corpus.stopwords.words('english'))
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')
stemmer = nltk.stem.SnowballStemmer('english')


class Command(BaseCommand):
    help = 'Scrape books from Gutendex and add them to the database'

    def create_Table(self):
        for format in Format.objects:
            if format.format_type in ['text/plain; charset=us-ascii', 'text/plain; charset=utf-8']:
                rawtext = requests.get(format.url).text
                tokens = nltk.tokenize.word_tokenize(rawtext)
                tokens = [word for word in tokens if word not in stop_words]
                tokens = [stemmer.stem(word) for word in tokens]
                for keyword in tokens:
                    if not Keyword.objects.filter(word=keyword).exists():
                        Keyword.objects.create(word=keyword)
                    Keyword.objects.get(word=keyword).books.add(format.book)
