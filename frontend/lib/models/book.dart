import 'dart:convert';

class Book {
  final int id;

  final String title;
  final List<dynamic> authors;
  final String imageUrl;
  final String textUrl;
  String subjects;
  final List<String> bookshelves;
  final List<dynamic> keywords;

  Book(
      {required this.id,
      required this.title,
      required this.authors,
      required this.imageUrl,
      required this.textUrl,
      required this.subjects,
      required this.bookshelves,
      required this.keywords});

  factory Book.fromJson(Map<String, dynamic> js) {
    String imageUrl = "";
    String textUrl = "";
    for (var url in js['urls']) {
      if (url['format_type'].contains('image')) {
        imageUrl = url['url'];
      }
      if (url['format_type'].contains('text')) {
        textUrl = url['url'];
      }
    }
    String subjects = js['subjects'];
    subjects = subjects.replaceAll('[', '');
    subjects = subjects.replaceAll(']', '');
    subjects = subjects.replaceAll('"', '');
    subjects = subjects.replaceAll('/', '');
    subjects = subjects.replaceAll('\'', '');
    return Book(
        id: js['id'],
        title: js['title'],
        authors: js['authors'],
        imageUrl: imageUrl,
        textUrl: textUrl,
        subjects: subjects,
        bookshelves: List<String>.from(
            json.decode((js['bookshelves'].replaceAll("'", '"')))),
        keywords: js['keywords']);
  }
}
