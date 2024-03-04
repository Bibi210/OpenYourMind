import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Align(
              alignment: Alignment.centerLeft, child: Text("OpenYourMind")),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight / 3,
                    left: screenWidth / 10,
                    right: screenWidth / 10),
                child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Enter a book name, author or genre",
                      prefixIcon: Icon(Icons.search),
                      filled: false,
                    ),
                    onSubmitted: (String value) {
                      Navigator.pushNamed(context, '/result');
                    }),
              ),
            ])));
  }
}
