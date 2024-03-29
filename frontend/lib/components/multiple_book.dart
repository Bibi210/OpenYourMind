import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/components/single_book.dart';
import '../models/book.dart';

class MultipleBook extends StatefulWidget {
  final bool isResultPage;
  final List<Book> books;
  final String label;

  const MultipleBook({
    super.key,
    required this.books,
    required this.label,
    required this.isResultPage,
  });

  @override
  State<MultipleBook> createState() => _MultipleBookState();
}

class _MultipleBookState extends State<MultipleBook> {
  
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.sizeOf(context).width >= 600;
    final appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 0;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - statusBarHeight - appBarHeight;

    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      height: widget.isResultPage ? availableHeight*0.95 : availableHeight * 0.75,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            child: widget.isResultPage
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          isScreenWide ? 4 : 1, // Adjust the number of columns
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: isScreenWide ? 80.0 : 10.0,
                    ),
                    itemCount: widget.books.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SingleBook(book: widget.books[index]);
                    })
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.books.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: isScreenWide
                            ? MediaQuery.of(context).size.width * 0.3
                            : MediaQuery.of(context).size.width * 0.8,
                        child: SingleBook(book: widget.books[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
