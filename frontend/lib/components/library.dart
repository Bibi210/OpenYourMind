import 'package:flutter/material.dart';
import 'package:frontend/manager/book_manager.dart';

import '../models/book.dart';


class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _Library();
}

class _Library extends State<Library> {
  BookManager _bookManager = BookManager();
  List<Book> books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopBooks();
  }

  void _loadTopBooks() async {
    var topBooks = await _bookManager.getTopBooks();
    setState(() {
      books = topBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5000,
      child: Column(
          children: <Widget>[
            const Text("Top Books", style: TextStyle(fontSize: 20)),
            Flexible(
                child:
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: SizedBox(
                              width: 200,
                              child:
                              Wrap(
                                  children: <Widget>[
                                    Image.network(books[index].imageUrl),
                                    ListTile(title: Text(books[index].title))
                                  ])));
                    })),
          ]
      ),
    );
  }
}