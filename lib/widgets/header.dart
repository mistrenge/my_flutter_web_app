import 'package:flutter/material.dart';
import 'package:my_flutter_app/styles/styles.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isSidebarOpen;
  final VoidCallback onSidebarToggle;

  const Header({
    super.key,
    required this.title,
    required this.isSidebarOpen,
    required this.onSidebarToggle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: fourthColor), // Title text color
      ),
      backgroundColor: secondaryColor,
      actions: [
        IconButton(
          icon: Icon(
            isSidebarOpen ? Icons.arrow_back : Icons.menu,
            color: Colors.white, // Icon color
          ),
          onPressed: onSidebarToggle,
        ),
      ],
    );
  }
}

