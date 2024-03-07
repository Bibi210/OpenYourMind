from gutendex.models import Book, JaccardIndex
from django.core.management.base import BaseCommand
import networkx as nx


class Command(BaseCommand):
    help = 'Compute the Jaccard index for each pair of books'

    def handle(self, *args, **kwargs):
        """ self.jaccardindex() """
        self.betweenness_centrality()

    def betweenness_centrality(self):
        G = nx.Graph()
        print('Creating graph')
        for book in Book.objects.all().order_by('id'):
            G.add_node(book.id)
        print('Graph created')
        print('Adding edges')
        jaccard_indexes = JaccardIndex.objects.all()
        average = sum([jaccard.index for jaccard in jaccard_indexes]) / len(jaccard_indexes)
        threshold = average + (average * 0.1)
        print(f'Average: {average}')
        print(f'Threshold: {threshold}')
        for jaccard in jaccard_indexes:
            if jaccard.index < threshold:
                G.add_edge(jaccard.book1_id, jaccard.book2_id)
        print(f'Edges added : {G.number_of_edges()}')
        print('Computing betweenness centrality')
        betweenness_centrality = nx.betweenness_centrality(G)
        print('Betweenness centrality computed')
        print('Writing betweenness centrality to database')
        for book_id, centrality in betweenness_centrality.items():
            book = Book.objects.get(id=book_id)
            book.betweenness_centrality = centrality
            book.save()
        print('Betweenness centrality computation finished')

    def jaccardindex(self):
        JaccardIndex.objects.all().delete()
        from django.db import connection
        nb_book = Book.objects.count()
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
            print(f'remaining books: {nb_book}')
            nb_book -= 1
        JaccardIndex.objects.filter(index=0).delete()
        print('Jaccard index computation finished')
