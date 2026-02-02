import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;

  const CustomeAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor:
      theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
      elevation: 0,
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
