import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';

class SearchBarCustom extends StatefulWidget {
  const SearchBarCustom({super.key});

  @override
  State<SearchBarCustom> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarCustom> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _hintText = "Enter a book name, author, or genre";

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _hintText = "Enter a book name, author, or genre";
        });
      }else {
        setState(() {
          _hintText = "";
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: _hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),

      ),
      onSubmitted: (String value) {
        if (value.trim().isNotEmpty) {
          Navigator.pushNamed(context, AppRoutes.searchResult, arguments: value);
        }
      },
      focusNode: _focusNode,
    );
  }
}
