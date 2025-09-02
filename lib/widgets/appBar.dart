import 'package:flutter/material.dart';
import 'package:task_manager/Login/LoginPage.dart';
import 'package:task_manager/widgets/app_colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
   final bool showLogout;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;

  CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
     this.showLogout = false,
    this.backgroundColor = primarycolor, 
    this.foregroundColor = textColorPrimary, 
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
      actions: [
        if (showLogout) 
          IconButton(
            icon: Icon(Icons.logout, color: foregroundColor),
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.rightSlide,
                title: 'Logout',
                desc: 'Are you sure you want to logout?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
                btnOkColor: Colors.red,
              ).show();
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}