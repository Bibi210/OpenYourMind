import 'package:flutter/material.dart';
import 'package:frontend/components/search_bar.dart'; // Assurez-vous que ce chemin est correct

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String? search;
  final bool isSearchBar;

  const AppBarCustom({super.key, required this.isSearchBar, this.search});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearchBar
          ? Row(
              children: [
                Expanded(
                  child: SearchBarCustom(isAppbar: true, search : search),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/AppBarLogo.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ],
            ),
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: isSearchBar
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
