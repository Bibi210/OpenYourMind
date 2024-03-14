import 'package:flutter/material.dart';

import '../apis/ApiCall.dart';
import '../models/book.dart';

class BookManager {
  final ApiCall _apiService = ApiCall();

  Future<List<Book>> getTopBooks() async {
    var data = await _apiService.fetchTopBooks();
    List<Book> books = [];
    for (var item in data) {
      books.add(Book.fromJson(item));
    }
    return books;
  }

  Future<List<Book>> getBooksBySearch(String search, int page) async {
    var data = await _apiService.fetchBooksBySearch(search, page);
    List<Book> books = [];
    for (var item in data) {
      books.add(Book.fromJson(item));
    }
    return books;
  }

  Future<List<Book>> getSuggestedBooks(int bookID) async {
    var data = await _apiService.fetchSuggestedBooks(bookID);
    List<Book> books = [];
    for (var item in data) {
      books.add(Book.fromJson(item));
    }
    return books;
  }
}
