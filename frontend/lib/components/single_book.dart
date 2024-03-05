import 'package:flutter/material.dart';
import '../models/book.dart';

class SingleBook extends StatelessWidget {
  final Book book;

  const SingleBook({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    print(book.authors);
    return Card(
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: 400,
                  child: Image.network(book.imageUrl,
                      fit: BoxFit.scaleDown,
                      width: MediaQuery.of(context).size.width * 0.2)),
              ListTile(title: Text(book.title),
              subtitle: Text(book.authors))
            ],
          ),
        );
  }
}
