import 'package:flutter/material.dart';
import '../models/book.dart';
import '../routes.dart';

class SingleBook extends StatelessWidget {
  final Book book;

  const SingleBook({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.bookDescription,
                  arguments: book);
            },
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Card(
                  surfaceTintColor: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0))),
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Image.network(book.imageUrl,
                              fit: BoxFit.scaleDown,
                              width: MediaQuery.of(context).size.width)),
                      Container(
                          color: Theme.of(context).colorScheme.surface,
                          child: ListTile(
                              title: Text(book.title),
                              subtitle: book.authors.isEmpty
                                  ? const Text("")
                                  : Text(book.authors
                                      .elementAt(0)['name']
                                      .toString()))),
                    ],
                  ),
                ))));
  }
}
