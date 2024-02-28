from django.contrib import admin
from .models import *

# Register your models here.

admin.site.register(Author)
admin.site.register(Book)
admin.site.register(Format)
admin.site.register(Keyword)
admin.site.register(BookKeyword)
