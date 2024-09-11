import 'package:flutter/material.dart';

class PostTextfield extends StatefulWidget {
  final TextEditingController controller;
  const PostTextfield({super.key, required this.controller});

  @override
  State<PostTextfield> createState() => _PostTextfieldState();
}

class _PostTextfieldState extends State<PostTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Yeni Post Yazın',
              hintText: 'Bir şeyler yazın...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Post Gönder'),
          ),
        ],
      ),
    );
  }
}
