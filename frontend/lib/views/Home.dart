import 'package:flutter/material.dart';
import 'package:frontend/components/multiple_book.dart';
import 'package:frontend/components/search_bar.dart';
import '../manager/book_manager.dart';
import '../models/book.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BookManager _bookManager = BookManager();
  List<Book>? books;

  void _loadTopBooks() async {
    try {
      var topBooks = await _bookManager.getTopBooks();
      setState(() => books = topBooks);
    } catch (e) {
      print(e);
      setState(() => books = []);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTopBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align (
          alignment: Alignment.center,
          child :
          Image.asset('assets/images/AppBarLogo.png',
              width : MediaQuery.of(context).size.width * 0.5)
        ),
        ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
              child: SearchBarCustom(),
            ),
            if (books == null)
              const CircularProgressIndicator()
            else if (books!.isEmpty)
              const Text('No top books found.')
            else
              MultipleBook(label: "Top Books", books: books!),
          ],
        ),
      ),
    );
  }
}
