import 'package:flutter/material.dart';

import '../components/app_bar_custom.dart';

class ResultPage extends StatefulWidget {
  final String search;
  const ResultPage({super.key, required this.search});

  @override
  State<ResultPage> createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBarCustom(isSearchBar : true, search: widget.search),
    );
  }
}
