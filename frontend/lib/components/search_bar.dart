import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';

class SearchBarCustom extends StatefulWidget {
  final String? search;
  final bool isAppbar;

  const SearchBarCustom({super.key, required this.isAppbar, this.search});

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
      } else {
        setState(() {
          _hintText = "";
        });
      }
    });
    _controller.text = widget.search ?? '';
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.008),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: _hintText,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            prefixIcon: widget.isAppbar
                ? null
                : Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary),
            filled: true,
            fillColor: widget.isAppbar
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
          onSubmitted: (String value) {
            if (value.trim().isNotEmpty) {
              Navigator.pushNamed(context, AppRoutes.searchResult,
                  arguments: value);
            }
          },
          focusNode: _focusNode,
        ));
  }
}
