from django.contrib import admin
from django.urls import path
from gutendex.views import TopBooks, SearchBook, GetHighestBetweenness, BookDetail, Suggest

urlpatterns = [
    path('admin/', admin.site.urls),
    path('top-books/', TopBooks.as_view(), name='top-books'),
    path('search/<str:sentence>/', SearchBook.as_view(), name='search-book-ordered-by-betweenness'),
    path('highest-betweenness/', GetHighestBetweenness.as_view(), name='highest-betweenness'),
    path('book/<int:pk>/', BookDetail.as_view(), name='book-detail'),
    path('suggest/<int:book_id>/', Suggest.as_view(), name='suggest-book-detail'),
]
