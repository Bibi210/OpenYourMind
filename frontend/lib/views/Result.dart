import 'package:flutter/material.dart';
import '../manager/book_manager.dart';
import '../models/book.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  final BookManager _bookManager = BookManager();
  List<String> content = [];
  bool _isLoading = true;
  late Book actualBook;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Book book = ModalRoute.of(context)!.settings.arguments as Book;
      loadContent(book);
    });
  }

  Future<void> loadContent(Book book) async {
      try {
        var contentBook = await _bookManager.getContentBook(book.textUrl);
        setState(() {
          content = contentBook;
          actualBook = book;
          _isLoading = false;
        });
      } catch(e) {
        print(e);
      }
  }

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)!.settings.arguments);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter List and Content'),
      ),
      body: _isLoading ? const CircularProgressIndicator() :
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.network(actualBook.imageUrl),
                  ],
                ),
                const SizedBox(width: 50), // Add spacing between columns
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chapter List:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 500,
                      child: Card(
                        surfaceTintColor: Theme.of(context).colorScheme.surface,
                        elevation: 3,
                        margin: const EdgeInsets.all(5),
                        child: SizedBox(
                          height: 500, // Adjust the height as needed
                          width: 500,
                          child: ListView.builder(
                            itemCount: content.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(content[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
