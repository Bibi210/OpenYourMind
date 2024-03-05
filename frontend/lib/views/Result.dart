import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  List<String> chapters = [];
  List<String> content = [];
  List<String> contentList = [];
  List<String> result = [];

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  void loadContent() async {
    String url = 'https://www.gutenberg.org/cache/epub/84/pg84.txt';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String fileContent = response.body;

        // Split the content into lines
        List<String> lines = fileContent.split('\n');

        // Find the index of the line containing "CONTENTS"
        contentList =
            lines.where((line) => line.startsWith(' CONTENTS')).toList();
        // Find the index of the line containing "CONTENTS"
        int contentsIndex = lines.indexOf(contentList.first);

        // Find the index of the first line after "CONTENTS" with only spaces
        int currentIndex = contentsIndex + 1;

        bool foundNonEmptyLine = false;

        while (currentIndex < lines.length) {
          String currentLine = lines[currentIndex].trim();
          if (currentLine.isNotEmpty) {
            foundNonEmptyLine = true;
            result.add(lines[currentIndex]);
          } else if (foundNonEmptyLine) {
            break;
          }
          currentIndex++;
        }

        content = result;
        print(content);
        // Extract lines starting from "CONTENTS" until the first empty line with spaces
        setState(() {}); // Trigger a rebuild after fetching the content
      } else {
        print('Failed to load content. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error reading the file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter List and Content'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(
              'https://www.designforwriters.com/wp-content/uploads/2017/10/design-for-writers-book-cover-tf-2-a-million-to-one.jpg',
            ),
            const SizedBox(height: 20),
            const Text(
              'Chapter List:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Display the chapter list using a ListView.builder
            ListView.builder(
              shrinkWrap: true,
              itemCount: content.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(content[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
