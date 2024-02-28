from django.db import models

# Create your models here.

from django.db import models


class Author(models.Model):
    name = models.CharField(max_length=255)
    birth_year = models.IntegerField(null=True, blank=True)
    death_year = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return self.name


class Book(models.Model):
    title = models.CharField(max_length=255)
    authors = models.ManyToManyField(Author, related_name='books')
    subjects = models.TextField(blank=True)
    bookshelves = models.TextField(blank=True)
    languages = models.CharField(max_length=50)
    copyright = models.BooleanField(default=False)
    media_type = models.CharField(max_length=50)
    download_count = models.IntegerField(default=0)

    def __str__(self):
        return self.title


class Format(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE, related_name='formats')
    format_type = models.CharField(max_length=100)
    url = models.URLField()

    def __str__(self):
        return f"{self.book.title} - {self.format_type}"
