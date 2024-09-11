import 'package:flutter/material.dart';

class InputTextfield extends StatefulWidget {
  final String text;
  final bool isHint;
  final IconData icon;
  final TextEditingController controller;
  const InputTextfield(
      {super.key,
      required this.text,
      required this.isHint,
      required this.icon,
      required this.controller});

  @override
  State<InputTextfield> createState() => _InputTextfieldState();
}

class _InputTextfieldState extends State<InputTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(15)),
        hintText: widget.text,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
      ),
      obscureText: widget.isHint,
    );
  }
}
