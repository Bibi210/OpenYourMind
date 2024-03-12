import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';

class SearchBarCustom extends StatefulWidget {
  final String? search;
  final bool isAppbar;
  final Function(String)? onSearch;

  const SearchBarCustom(
      {super.key, required this.isAppbar, this.search, this.onSearch});

  @override
  State<SearchBarCustom> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarCustom> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
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
            suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                    });
                  },
                )
              : null,
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
              widget.isAppbar
                  ? widget.onSearch?.call(value)
                  : Navigator.pushNamed(context, AppRoutes.searchResult,
                          arguments: value)
                      .then((result) {
                      if (result == 'reset') {
                        _controller.clear();
                      }
                    });
            }
          },
          focusNode: _focusNode,
        ));
  }
}
