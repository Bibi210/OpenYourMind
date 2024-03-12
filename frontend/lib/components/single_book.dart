import 'package:flutter/material.dart';
import 'package:frontend/components/book_image.dart';
import '../models/book.dart';
import '../routes.dart';

class SingleBook extends StatelessWidget {
  final Book book;

  const SingleBook({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          child: Column(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.bookDescription,
                        arguments: book);
                  },
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0))),
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: BookImage(
                              imageUrl: book.imageUrl, inCard: true)))),
              Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: ListTile(
                      title: Text(book.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: book.authors.isEmpty
                          ? const Text("")
                          : Text(book.authors.elementAt(0)['name'].toString(),
                              maxLines: 1, overflow: TextOverflow.ellipsis))),
            ],
          ),
        ));
  }
}
