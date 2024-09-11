import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  DrawerTile(
      {super.key, required this.icon, required this.text, required this.onTap});
  final IconData icon;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 18,
          ),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        onTap: onTap,
      ),
    );
  }
}
