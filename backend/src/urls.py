from django.contrib import admin
from django.urls import path
from gutendex.views import TopBooks

urlpatterns = [
    path('admin/', admin.site.urls),
    path('top-books/', TopBooks.as_view(), name='top-books'),
]
