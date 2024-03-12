import 'package:flutter/material.dart';
import 'package:frontend/components/search_bar.dart'; // Assurez-vous que ce chemin est correct

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String? search;
  final bool isSearchBar;
  final Function(String)? onSearch;
  final bool? isReset;

  const AppBarCustom(
      {super.key,
      required this.isSearchBar,
      this.search,
      this.onSearch,
      this.isReset});

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.sizeOf(context).width >= 600;
    return AppBar(
      title: isSearchBar
          ? Row(
              children: isScreenWide
                  ? [
                      Image.asset(
                        'assets/images/AppBarLogo.png',
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      Expanded(
                        child: SearchBarCustom(
                            isAppbar: true, search: search, onSearch: onSearch),
                      )
                    ]
                  : [
                      Expanded(
                        child: SearchBarCustom(
                            isAppbar: true, search: search, onSearch: onSearch),
                      )
                    ])
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/AppBarLogo.png',
                  width: isScreenWide
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.5,
                ),
              ],
            ),
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: isSearchBar
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => isReset!
                  ? Navigator.pop(context, 'reset')
                  : Navigator.of(context).pop())
          : null,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
