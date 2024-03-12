import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiCall {
  final String _baseUrl = "http://127.0.0.1:8000/";

  Future<dynamic> fetchTopBooks() async {
    var url = Uri.parse("${_baseUrl}top-books");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> allBooks = jsonDecode(response.body);

      // Take the first 10 elements
      List<dynamic> top10Books = allBooks.take(10).toList();

      return top10Books;
    } else {
      throw Exception('Failed to load top books');
    }
  }

  Future<dynamic> fetchBooksBySearch(String search) async {
    var url = Uri.parse("${_baseUrl}search/$search");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load books by search');
    }
  }

  Future<dynamic> fetchSuggestedBooks(int bookId) async {
    var url = Uri.parse("${_baseUrl}suggest/$bookId");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> allBooks = jsonDecode(response.body);

      // Take the first 10 elements
      List<dynamic> topSuggestedBooks = allBooks.take(10).toList();

      return topSuggestedBooks;
    } else {
      throw Exception('Failed to load books by search');
    }
  }
}
