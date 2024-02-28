from django.core.management.base import BaseCommand
import requests
from gutendex.models import Book, Author, Format

number_books = 0

def read_book(url):
    if url is not None:
        response = requests.get(url)
        if response.status_code == 200:
            return response.text
        else:
            return []
    return []


def add_books_to_db(books_data):
    global number_books
    for book_data in books_data:
        if "en" in book_data['languages']:
            book_to_read = book_data['formats'].get('text/plain; charset=utf-8',
                                                    book_data['formats'].get('text/plain; charset=us-ascii'))
            if len(read_book(book_to_read)) > 10000:
                book, created = Book.objects.update_or_create(
                    id=book_data['id'],
                    title=book_data['title'],
                    subjects=book_data['subjects'],
                    bookshelves=book_data['bookshelves'],
                    languages=book_data['languages'],
                    copyright=book_data['copyright'],
                    media_type=book_data['media_type'],
                    download_count=book_data['download_count']
                )
                authors = [Author.objects.get_or_create(
                    name=author['name'])[0] for author in book_data['authors']]
                book.authors.set(authors)
                book.save()

                for format_type, url in book_data['formats'].items():
                    urls, created = Format.objects.update_or_create(
                        book=book,
                        format_type=format_type,
                        url=url
                    )
                    urls.save()
                number_books += 1

                print(f'Added book: {book.title}')


class Command(BaseCommand):
    help = 'Scrape books from Gutendex and add them to the database'

    def handle(self, *args, **kwargs):
        i = 1
        base_url = "https://gutendex.com/books/?page="

        while number_books < 1664:
            response = requests.get(base_url + str(i))
            i += 1
            if response.status_code == 200:
                books = response.json()['results']
                add_books_to_db(books)
                print("Books added: ", number_books)
            else:
                print('Failed to fetch books')
                break
