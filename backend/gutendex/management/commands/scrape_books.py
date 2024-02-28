from django.core.management.base import BaseCommand
import requests
from gutendex.models import Book, Author


class Command(BaseCommand):
    help = 'Scrape books from Gutendex and add them to the database'

    def add_books_to_db(self, books_data):
        for book_data in books_data:
            book = Book.objects.create(
                id=book_data['id'],
                title=book_data['title'],
                subjects=book_data['subjects'],
                bookshelves=book_data['bookshelves'],
                languages=book_data['languages'],
                download_count=book_data['download_count'],

            )
            authors = [Author.objects.get_or_create(name=author['name'])[0] for author in book_data['authors']]
            book.authors.set(authors)
            book.save()
            print(f'Added book: {book.title}')

    def handle(self, *args, **kwargs):
        base_url = "http://gutendex.com/books/"
        books_added = 0

        while books_added < 1664:
            response = requests.get(base_url)
            if response.status_code == 200:
                books = response.json()['results']
                self.add_books_to_db(books)
                books_added += len(books)
            else:
                print('Failed to fetch books')
                break

            # Vérification du nombre de lignes pour chaque livre peut être complexe et nécessiter le téléchargement de chaque livre, ce qui n'est pas couvert dans cet exemple simplifié.
