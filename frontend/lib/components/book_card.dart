import 'package:flutter/material.dart';
import 'package:frontend/components/text_content_card.dart';
import 'package:frontend/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              TextContentCard(
                  text1: "Authors: ",
                  text2: book.authors.elementAt(0)["name"].toString()),
              const SizedBox(height: 6),
              TextContentCard(text1: "Subjects: ", text2: book.subjects),
              const SizedBox(height: 8),
              TextContentCard(
                  text1: "Bookshelves: ", text2: book.bookshelves.join(", "))
            ],
          ),
        ),
      ),
    );
  }
}
