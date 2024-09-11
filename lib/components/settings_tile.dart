import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.title, required this.action});
  final String title;
  final Widget action;
  @override
  Widget build(BuildContext context) {
    //i wrap listtile with container
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
      //elemanlar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          action,
        ],
      ),
    );
  }
}
