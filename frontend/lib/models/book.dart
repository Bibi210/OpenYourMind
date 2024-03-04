class Book {
  final int id;

  final String title;
  final List<dynamic> authors;
  final String imageUrl;
  final String textUrl;
  final String subjects;
  final String bookshelves;
  final List<String> keywords;

  Book({required this.id,
    required this.title,
    required this.authors,
    required this.imageUrl,
    required this.textUrl,
    required this.subjects,
    required this.bookshelves,
    required this.keywords});

  factory Book.fromJson(Map<String, dynamic> json) {
    String imageUrl = "";
    String textUrl = "";
    for (var url in json['urls']) {
      if (url['format_type'].contains('image')) {
        imageUrl = url['url'];
      }
      if (url['format_type'].contains('text')) {
        textUrl = url['url'];
      }
    }
    return Book(
        id: json['id'],
        title: json['title'],
        authors : json['authors'],
        imageUrl: imageUrl,
        textUrl: textUrl,
        subjects: json['subjects'],
        bookshelves: json['bookshelves'],
        keywords: json['keywords'].cast<String>());
    }
}
