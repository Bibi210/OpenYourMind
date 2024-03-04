import nltk
import requests
from django.core.management.base import BaseCommand
from gutendex.models import Keyword, Format, BookKeyword

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
                tokens = [word.lower() for word in tokens if word.isalpha() and word.lower() not in stop_words]
                tokens = [stemmer.stem(word) for word in tokens]

                word_counts = {}
                for word in tokens:
                    # Get word occurrences if not in dic then 0
                    word_counts[word] = word_counts.get(word, 0) + 1

                total_words = len(tokens)

                for word, count in word_counts.items():
                    keyword, created = Keyword.objects.get_or_create(word=word)
                    repetition_percentage = (count / total_words) * 100

                    BookKeyword.objects.update_or_create(
                        book=format.book,
                        keyword=keyword,
                        occurrences = count,
                        repetition_percentage = repetition_percentage
                    )
            print(f'End book {format.book.title}')