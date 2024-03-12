import 'package:flutter/material.dart';
import 'package:frontend/components/multiple_book.dart';
import 'package:frontend/manager/book_manager.dart';
import 'package:frontend/models/book.dart';

import '../components/app_bar_custom.dart';

class ResultPage extends StatefulWidget {
  final String search;
  const ResultPage({super.key, required this.search});

  @override
  State<ResultPage> createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  final BookManager _bookManager = BookManager();
  List<Book>? books;

  void _loadResultBooks() async {
    try {
      var resultBooks = await _bookManager.getBooksBySearch(widget.search);
      setState(() => books = resultBooks);
    } catch (e) {
      setState(() => books = []);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadResultBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(isSearchBar: true, search: widget.search),
      body: books == null
          ? const CircularProgressIndicator()
          : (books!.isEmpty)
              ? const Text('No books found.')
              : MultipleBook(
                  isResultPage: true, label: "Search Results", books: books!),
    );
  }
}
