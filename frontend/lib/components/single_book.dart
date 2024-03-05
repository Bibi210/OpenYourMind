import 'package:flutter/material.dart';
import '../models/book.dart';

class SingleBook extends StatelessWidget {
  final Book book;

  const SingleBook({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding (
        padding : const EdgeInsets.symmetric(horizontal: 10),
        child : GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/result', arguments: book);
        },
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Card(
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              child: Column(
                children: <Widget>[
                  SizedBox(
                      height: 400,
                      child: Image.network(book.imageUrl,
                          fit: BoxFit.scaleDown,
                          width: MediaQuery.of(context).size.width * 0.2)),
                  ListTile(
                      title: Text(book.title), subtitle: Text(book.authors))
                ],
              ),
            ))));
  }
}
