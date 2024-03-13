from gutendex.views import SearchBook, get_token
from gutendex.models import Book, JaccardIndex, Keyword, Suggestions
from django.db.models import Q
from django.core.management.base import BaseCommand
import networkx as nx


class Command(BaseCommand):
    help = 'Compute the Jaccard index for each pair of books'

    def handle(self, *args, **kwargs):
        """ self.jaccardindex()
        self.compute_centrality() """
        self.pre_suggest_books()

    def pre_suggest_books(self):
        Suggestions.objects.all().delete()
        books = Book.objects
        nb_books = books.count()
        for book in books.all():
            print(f'Processing book: {book.title}')
            idf_sorted_tokens = sorted(get_token(book.title), key=lambda token: Keyword.objects.get(
                word=token).idf, reverse=True)[:2]
            print(f'Best tokens: {idf_sorted_tokens}')
            queryset = SearchBook().search(tokens=idf_sorted_tokens)
            queryset.remove(book)
            jaccard_index_map = {}
            if len(queryset) == 0:
                queryset = Book.objects.all().exclude(id=book.id)
            for b in queryset:
                index = JaccardIndex.objects.get(Q(book1=book, book2=b) | Q(book1=b, book2=book))
                jaccard_index_map[b] = index.index
            averageindex = sum(jaccard_index_map.values()) / len(jaccard_index_map)
            suggestions = list(filter(lambda b: jaccard_index_map[b] < averageindex, queryset))
            obj = Suggestions.objects.create(book=book)
            obj.suggested_books.set(suggestions)
            obj.save()
            nb_books -= 1
            print(f'Remaining books: {nb_books}')
        print('Suggestion computation finished')

    def compute_centrality(self):
        G = nx.Graph()
        print('Creating graph')
        for book in Book.objects.all().order_by('id'):
            G.add_node(book.id)
        print('Graph created')
        print('Adding edges')
        jaccard_indexes = JaccardIndex.objects.all()
        average = sum([jaccard.index for jaccard in jaccard_indexes]) / len(jaccard_indexes)
        threshold = average - (average * 0.3)
        print(f'Threshold: {threshold}')
        for jaccard in jaccard_indexes:
            if jaccard.index < threshold:
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
        descOrder = Book.objects.order_by('-id')
        for book in descOrder:
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
