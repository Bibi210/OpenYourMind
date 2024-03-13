from django.db import models


class Author(models.Model):
    name = models.CharField(max_length=255)
    birth_year = models.IntegerField(null=True, blank=True)
    death_year = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return self.name


class Keyword(models.Model):
    word = models.CharField(max_length=255, null=True, db_index=True)
    idf = models.FloatField(default=0.0)

    def __str__(self):
        return self.word


class Book(models.Model):
    id = models.IntegerField(primary_key=True)
    title = models.CharField(max_length=255)
    authors = models.ManyToManyField(Author, related_name='books')
    subjects = models.TextField(blank=True)
    bookshelves = models.TextField(blank=True)
    languages = models.CharField(max_length=50)
    copyright = models.BooleanField(default=False)
    media_type = models.CharField(max_length=50)
    download_count = models.IntegerField(default=0)
    keywords = models.ManyToManyField('Keyword', through='BookKeyword', related_name='books')
    betweenness_centrality = models.FloatField(default=0.0)
    closeness_centrality = models.FloatField(default=0.0)

    def __str__(self):
        return self.title


class Format(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE, related_name='formats')
    format_type = models.CharField(max_length=100)
    url = models.URLField()

    def __str__(self):
        return f"{self.book.title} - {self.format_type}"
    

class Suggestions(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE, related_name='book')
    suggested_books = models.ManyToManyField(Book, related_name='suggested_books')

    def __str__(self):
        return f"{self.book.title} - {self.suggested_books.title}"


class BookKeyword(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    keyword = models.ForeignKey(Keyword, on_delete=models.CASCADE)
    occurrences = models.IntegerField(default=0)
    repetition_percentage = models.FloatField(default=0.0)

    def __str__(self):
        return f"{self.book.title} - {self.keyword.word}"


class JaccardIndex(models.Model):
    book1 = models.ForeignKey(Book, on_delete=models.CASCADE, related_name='book1')
    book2 = models.ForeignKey(Book, on_delete=models.CASCADE, related_name='book2')
    index = models.FloatField(default=0.0)

    def __str__(self):
        return f"{self.book1.title} - {self.book2.title} - {self.index}"
