from django.contrib import admin
from django.urls import path
from gutendex.views import TopBooks, SearchBook

urlpatterns = [
    path('admin/', admin.site.urls),
    path('top-books/', TopBooks.as_view(), name='top-books'),
    path('search/<str:word>', SearchBook.as_view(), name='search-book'),
]
