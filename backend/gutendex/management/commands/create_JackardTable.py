from gutendex.models import Book, BookKeyword, JaccardIndex
from itertools import combinations
from django.db import models
from django.db.models import F, Value
from django.db.models.functions import Coalesce
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = 'Compute the Jaccard index for each pair of books'

    def handle(self, *args, **kwargs):
        JaccardIndex.objects.all().delete()
        from django.db import connection
        nbBooks = Book.objects.count()
        for book in Book.objects.all():
            raw_query = f"""
            INSERT INTO gutendex_jaccardindex (book1_id, book2_id, "index")
            SELECT
                BK1.book_id AS book1_id,
                BK2.book_id AS book2_id,
                CASE
                    WHEN SUM(MAX(BK1.occurrences, COALESCE(BK2.occurrences, 0))) > 0 THEN
                        1 - CAST(SUM(MIN(BK1.occurrences, COALESCE(BK2.occurrences, 0))) AS FLOAT) / SUM(MAX(BK1.occurrences, COALESCE(BK2.occurrences, 0)))
                    ELSE
                        0
                END AS jaccard_index
            FROM
                gutendex_bookkeyword BK1
            LEFT JOIN
                gutendex_bookkeyword BK2 ON BK1.keyword_id = BK2.keyword_id
            WHERE
                BK1.book_id < BK2.book_id AND BK1.book_id = {book.id}
            GROUP BY
                BK1.book_id, BK2.book_id;
            """
            # Execute the raw SQL query
            with connection.cursor() as cursor:
                cursor.execute(raw_query)
            print(f'Processed book: {book.title}')
            print(f'remaining books: {nbBooks}')
            nbBooks -= 1
        JaccardIndex.objects.filter(index=0).delete()
        print('Jaccard index computation finished')
