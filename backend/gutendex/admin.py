from django.contrib import admin
from .models import Author, Book, Format, Keyword

# Register your models here.

admin.site.register(Author)
admin.site.register(Book)
admin.site.register(Format)
admin.site.register(Keyword)
