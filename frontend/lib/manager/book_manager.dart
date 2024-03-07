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

  Future<List<Book>> getBooksBySearch(String search) async {
    var data = await _apiService.fetchBooksBySearch(search);
    List<Book> books = [];
    for (var item in data) {
      books.add(Book.fromJson(item));
    }
    return books;
  }

}