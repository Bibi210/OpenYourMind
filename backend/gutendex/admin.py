from django.contrib import admin
from .models import Author, Book, Format

# Register your models here.

admin.site.register(Author)
admin.site.register(Book)
admin.site.register(Format)
