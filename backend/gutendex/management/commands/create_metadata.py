import networkx as nx
from django.core.management.base import BaseCommand
from django.db.models import Q
from gutendex.models import Book, JaccardIndex, Keyword, Suggestions
from gutendex.views import get_token
from gutendex.helpers import get_threasold_for_graph, get_threasold_for_ls, raw_tokenize, search_token


class Command(BaseCommand):
    help = 'Compute the Jaccard index for each pair of books'

    def handle(self, *args, **kwargs):
        self.jaccardindex()
        self.compute_centrality()

    def compute_centrality(self):
        G = nx.Graph()
        print('Creating graph')
        for book in Book.objects.all():
            G.add_node(book.id)
        print('Graph created')
        print('Adding edges')
        jaccard_indexes = JaccardIndex.objects.all()
        threshold = get_threasold_for_graph()
        print(f'Threshold: {threshold}')
        for jaccard in jaccard_indexes:
            if jaccard.index >= threshold:
                G.add_edge(jaccard.book1_id, jaccard.book2_id)
        print(f'Edges added : {G.number_of_edges()}')
        print('Computing centrality')
        betweenness_centrality = nx.betweenness_centrality(G)
        closeness_centrality = nx.closeness_centrality(G)
        print('Centrality computed')
        print('Writing centrality to database')
        for book in Book.objects.all():
            book.betweenness_centrality = betweenness_centrality[book.id]
            book.closeness_centrality = closeness_centrality[book.id]
            book.save()
        print('Centrality computation finished')

    def jaccardindex(self):
        JaccardIndex.objects.all().delete()
        from django.db import connection
        nb_book = Book.objects.count()
        desc_order = Book.objects.order_by('id')
        for book in desc_order:
            raw_query = f"""
            INSERT INTO gutendex_jaccardindex (book1_id, book2_id, "index")
            SELECT
                BK1.book_id AS book1_id,
                BK2.book_id AS book2_id,
                CASE
                    WHEN SUM(MAX(BK1.occurrences, COALESCE(BK2.occurrences, 0))) > 0 THEN
                        CAST(SUM(MIN(BK1.occurrences, COALESCE(BK2.occurrences, 0))) AS FLOAT) / SUM(MAX(BK1.occurrences, COALESCE(BK2.occurrences, 0)))
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
