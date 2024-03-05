import 'package:flutter/material.dart';
import 'package:frontend/components/single_book.dart';
import '../models/book.dart';

class MultipleBook extends StatefulWidget {
  final List<Book> books;
  final String label;

  const MultipleBook(
      {super.key, required this.books, required this.label});

  @override
  State<MultipleBook> createState() => _MultipleBookState();
}

class _MultipleBookState extends State<MultipleBook> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color : Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.label),
          ),
          SizedBox(
            height : 500,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.books.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox (
                  width : MediaQuery.of(context).size.width * 0.2,
                  child : SingleBook(book: widget.books[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}
