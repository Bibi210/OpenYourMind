from gutendex.models import Book, JackardIndex
from django.core.management.base import BaseCommand
import os
import sys
from multiprocessing.dummy import Pool as ThreadPool


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


class Command(BaseCommand):
    nbCpus = os.cpu_count()
    help = 'Compute the Jaccard index for each pair of books'

    def handle(self, *args, **kwargs):
        self.create_JackardTable()

    def compute_JaccardIndex(self, book1, book2):
        book1_keywords = set(book1.keywords.all())
        book2_keywords = set(book2.keywords.all())
        intersection = len(book1_keywords.intersection(book2_keywords))
        union = len(book1_keywords.union(book2_keywords))
        eprint(f'Computing Jaccard index for {book1.id}')
        JackardIndex.objects.update_or_create(
            book1=book1,
            book2=book2,
            defaults={'index': intersection / union}
        )

    def create_JackardTable(self):
        with ThreadPool(self.nbCpus) as p:
            books = Book.objects.all().order_by('id')
            duo = [(book1, book2) for book1 in books for book2 in books if book1.id < book2.id]
            duo.sort(key=lambda x: x[0].id)
            p.starmap(self.compute_JaccardIndex, duo)
            p.close()
            p.join()
        print('Jackard index computation finished')
