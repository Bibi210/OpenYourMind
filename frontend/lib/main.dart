import 'package:flutter/material.dart';
import 'package:frontend/views/BookPage.dart';
import 'package:frontend/views/Home.dart';
import 'package:frontend/views/Result.dart';
import 'routes.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const MyHomePage(),
        AppRoutes.book: (context) => const BookPage(),
        AppRoutes.result: (context) => const ResultPage(),
      },
    );
  }
}
