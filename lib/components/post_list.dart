import 'package:flutter/material.dart';
import 'package:twitter/models/post.dart';

class PostList extends StatefulWidget {
  final Post post;
  const PostList({super.key, required this.post});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child:
            Text(widget.post.name[0]), // İsmin ilk harfini gösteren bir avatar
      ),
      title: Text(widget.post.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.post.message),
          SizedBox(height: 5),
          Text(
            '${widget.post.timestamp}'.split(' ')[0], // Tarih formatı
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, color: Colors.red),
          Text('${widget.post.likeCount}'),
        ],
      ),
      onTap: () {
        // Post üzerine tıklama durumunda yapılacak işlemler
        print("Post tapped: ${widget.post.id}");
      },
    );
  }
}
