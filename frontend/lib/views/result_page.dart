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
  List<Book>? nextBooks;
  bool isLoading = false;

  void _loadResultBooks(int page) async {
    try {
      var resultBooks =
          await _bookManager.getBooksBySearch(widget.search, page);
      var resultNextBooks =
          await _bookManager.getBooksBySearch(widget.search, page + 1);
      setState(() {
        currentSearch = widget.search;
        books = resultBooks;
        nextBooks = resultNextBooks;
      });
    } catch (e) {
      setState(() => books = []);
    }
  }

  void _loadResultAndUpdateBooks(String query, int page) async {
    try {
      setState(() {
        isLoading = true; // Set isLoading to true when data fetching starts
      });
      var resultBooks = await _bookManager.getBooksBySearch(query, page);
      var resultNextBooks =
          await _bookManager.getBooksBySearch(query, page + 1);
      nextBooks = resultNextBooks;
      setState(() {
        books = resultBooks;
        isLoading =
            false; // Set isLoading to false after data fetching completes
      });
    } catch (e) {
      setState(() {
        books = [];
        isLoading =
            false; // Set isLoading to false if an error occurs during data fetching
      });
    }
  }

  void _searchAndUpdateBooks(String query, int page) {
    setState(() {
      books = null;
      currentSearch = query;
      currentPage = page;
    });
    print(
        'Before _loadResultAndUpdateBooks: nextBooks: $nextBooks, isLoading: $isLoading, currentPage: $currentPage');
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
        body: SingleChildScrollView(
            child: (books == null
                ? const Center(child: CircularProgressIndicator())
                : (books!.isEmpty)
                    ? const Text(
                        'No books found.',
                        textAlign: TextAlign.center,
                      )
                    : Column(
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
                                onPressed: nextBooks!.isNotEmpty
                                    ? () {
                                        currentPage++;
                                        _loadResultAndUpdateBooks(
                                            currentSearch, currentPage);
                                      }
                                    : null,
                                icon: const Icon(Icons.arrow_forward),
                              )
                            ],
                          ),
                        ],
                      ))));
  }
}
