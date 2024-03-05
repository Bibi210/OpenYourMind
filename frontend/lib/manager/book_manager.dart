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

  Future<List<String>> getContentBook(String url) async {
    var data = await _apiService.fetchBookText(url);
    List<String> content = [];
    List<String> contentList = [];

    List<String> lines = data.split("\n").take(100).toList();
    contentList = lines.where((line) => line.startsWith(' CONTENTS')).toList();
    int contentsIndex = lines.indexOf(contentList.first);

    int currentIndex = contentsIndex + 1;

    bool foundNonEmptyLine = false;

    while (currentIndex < lines.length) {
      String currentLine = lines[currentIndex].trim();
      if (currentLine.isNotEmpty) {
        foundNonEmptyLine = true;
        content.add(lines[currentIndex]);
      } else if (foundNonEmptyLine) {
        break;
      }
      currentIndex++;
    }
    return content;
  }

}