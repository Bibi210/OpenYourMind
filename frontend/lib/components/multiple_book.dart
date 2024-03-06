import 'package:flutter/material.dart';
import 'package:frontend/components/single_book.dart';
import '../models/book.dart';

class MultipleBook extends StatefulWidget {
  final List<Book> books;
  final String label;

  const MultipleBook({super.key, required this.books, required this.label});

  @override
  State<MultipleBook> createState() => _MultipleBookState();
}

class _MultipleBookState extends State<MultipleBook> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 20),
            child: Text(widget.label),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.books.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SingleBook(book: widget.books[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}
