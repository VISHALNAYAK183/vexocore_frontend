// lib/widgets/app_bar.dart
import 'package:flutter/material.dart';
import 'package:task_manager/widgets/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;

  // Remove 'const' here
  CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.backgroundColor = primarycolor, // still fine
    this.foregroundColor = textColorPrimary, // still fine
    this.elevation = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: foregroundColor,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: foregroundColor),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
