import 'package:flutter/material.dart';




class AppBarCustom extends StatelessWidget implements PreferredSizeWidget{
  const AppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Align (
          alignment: Alignment.topCenter,
          child :
          Image.asset('assets/images/AppBarLogo.png',
              width : MediaQuery.of(context).size.width * 0.5)
      ),
      surfaceTintColor: Theme.of(context).colorScheme.surface,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}