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
  int currentPage = 1;
  String currentSearch = '';
  final BookManager _bookManager = BookManager();
  List<Book>? books;

  void _loadResultBooks(int page) async {
    try {
      var resultBooks =
          await _bookManager.getBooksBySearch(widget.search, page);
      currentSearch = widget.search;
      setState(() => books = resultBooks);
    } catch (e) {
      setState(() => books = []);
    }
  }

  void _loadResultAndUpdateBooks(String query, int page) async {
    try {
      currentPage = page;
      currentSearch = query;
      var resultBooks = await _bookManager.getBooksBySearch(query, page);
      setState(() => books = resultBooks);
    } catch (e) {
      setState(() => books = []);
    }
  }

  void _searchAndUpdateBooks(String query, int page) {
    currentSearch = query;
    currentPage = page;
    setState(() {
      books = null;
    });
    _loadResultAndUpdateBooks(query, page);
  }

  @override
  void initState() {
    super.initState();
    _loadResultBooks(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(
            isSearchBar: true,
            isReset: true,
            search: widget.search,
            onSearch: (query) => _searchAndUpdateBooks(query, 1)),
        body: (books == null
            ? const Center(child: CircularProgressIndicator())
            : (books!.isEmpty)
                ? const Text(
                    'No books found.',
                    textAlign: TextAlign.center,
                  )
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      MultipleBook(
                          isResultPage: true,
                          label: "Search Results",
                          books: books!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: currentPage > 1
                                ? () {
                                    setState(() {
                                      currentPage--; // Decrement the current page
                                      _loadResultAndUpdateBooks(
                                          currentSearch, currentPage);
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_back),
                          ),
                          Text('Page $currentPage'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentPage++; // Increment the current page
                                _loadResultAndUpdateBooks(
                                    currentSearch, currentPage);
                              });
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ],
                  ))));
  }
}
