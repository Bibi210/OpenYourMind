import 'package:flutter/material.dart';
import 'package:frontend/components/single_book.dart';
import '../models/book.dart';

class MultipleBook extends StatefulWidget {
  final bool isResultPage;
  final List<Book> books;
  final String label;

  const MultipleBook({super.key, required this.books, required this.label,required this.isResultPage});

  @override
  State<MultipleBook> createState() => _MultipleBookState();
}

class _MultipleBookState extends State<MultipleBook> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(widget.label,
              style : const TextStyle(
                fontWeight : FontWeight.bold,
                fontSize : 18
              ) ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView.builder(
              scrollDirection: widget.isResultPage ? Axis.vertical : Axis.horizontal,
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
