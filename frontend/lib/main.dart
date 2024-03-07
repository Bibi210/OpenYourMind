import 'package:flutter/material.dart';
import 'package:frontend/views/Home.dart';
import 'package:frontend/views/book_description_page.dart';
import 'models/book.dart';
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
      onGenerateRoute: (RouteSettings settings) {
        // Gestion des routes en fonction de settings.name
        switch (settings.name) {
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const MyHomePage());
          case AppRoutes.bookDescription:
            final book = settings.arguments as Book;
            return MaterialPageRoute(builder: (_) => BookDescriptionPage(book: book));
          case AppRoutes.searchResult:
            //return MaterialPageRoute(builder: (_) => const ResultPage());
          case AppRoutes.bookContent:
            //return MaterialPageRoute(builder: (_) => const ResultPage());
          default:
          // Gestion des routes non définies
            return MaterialPageRoute(builder: (_) => const MyHomePage());
        }
      },

    );
  }
}
