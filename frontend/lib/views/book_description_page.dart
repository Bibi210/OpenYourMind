import 'package:flutter/material.dart';
import 'package:frontend/components/book_card.dart';
import 'package:frontend/components/book_image.dart';
import 'package:frontend/components/multiple_book.dart';
import '../components/app_bar_custom.dart';
import '../components/button_custom.dart';
import '../models/book.dart';
import 'package:url_launcher/url_launcher.dart';
import '../manager/book_manager.dart';

class BookDescriptionPage extends StatefulWidget {
  final Book book;
  const BookDescriptionPage({super.key, required this.book});
  @override
  State<BookDescriptionPage> createState() => _BookDescriptionPage();
}

class _BookDescriptionPage extends State<BookDescriptionPage> {
  final BookManager _bookManager = BookManager();
  List<Book>? books;

  void _loadSuggestedBooks() async {
    try {
      var suggestedBooks = await _bookManager.getSuggestedBooks(widget.book.id);
      setState(() => books = suggestedBooks);
    } catch (e) {
      setState(() => books = []);
    }
  }

  @override
  void initState() {
    _loadSuggestedBooks();
    super.initState();
  }

  _launchURL() async {
    final Uri url = Uri.parse(widget.book.textUrl.toString());
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        isSearchBar: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BookImage(imageUrl: widget.book.imageUrl),
                CustomButton(text: "Read Book", onPressed: _launchURL),
                // Add spacing between columns
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                BookCard(book: widget.book),
              ],
            ),
            const SizedBox(height: 20),
            if (books == null)
              const CircularProgressIndicator()
            else if (books!.isEmpty)
              const Text('No books found.')
            else
              MultipleBook(
                  label: "You may like this",
                  books: books!,
                  isResultPage: false)
          ],
        ),
      ),
    );
  }
}
