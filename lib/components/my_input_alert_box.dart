import 'package:flutter/material.dart';

class MyInputAlertBox extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;
  final String title;

  const MyInputAlertBox({
    super.key,
    required this.textController,
    required this.hintText,
    this.onPressed,
    required this.onPressedText,
    required this.title,
  });

  @override
  State<MyInputAlertBox> createState() => _MyInputAlertBoxState();
}

class _MyInputAlertBoxState extends State<MyInputAlertBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        widget.title,
        style: TextStyle(
            fontSize: 12, color: Theme.of(context).colorScheme.primary),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: TextField(
        controller: widget.textController,
        maxLength: 140,
        maxLines: 3,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Theme.of(context).colorScheme.secondary,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          filled: true,
        ),
      ),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Geri"),
            ),
            Spacer(),
            TextButton(
              onPressed: widget.onPressed, // onPressed işlevini kullanın
              child: Text(
                widget.onPressedText,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }
}
