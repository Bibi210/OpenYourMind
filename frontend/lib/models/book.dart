import 'dart:convert';

class Book {
  final int id;

  final String title;
  final List<dynamic> authors;
  final String imageUrl;
  final String textUrl;
  String subjects;
  final List<String> bookshelves;

  Book(
      {required this.id,
      required this.title,
      required this.authors,
      required this.imageUrl,
      required this.textUrl,
      required this.subjects,
      required this.bookshelves});

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
    print(js['bookshelves'].replaceAll('"',""));
    print(js['authors']);

    String bookshelvescleaned = js['bookshelves'].substring(1, js['bookshelves'].length - 1);


    return Book(
        id: js['id'],
        title: js['title'],
        authors: js['authors'],
        imageUrl: imageUrl,
        textUrl: textUrl,
        subjects: subjects,
        bookshelves: bookshelvescleaned.split(','));
  }
}
