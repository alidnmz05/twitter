import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/services/database/database_provider.dart';

import '../models/post.dart';
import '../screens/other_profile_page.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  const MyPostTile({super.key, required this.post});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  //user tapped like or unlike
  void _toogleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              title: Text("Delete"),
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text("Cancel"),
              leading: Icon(Icons.cancel,
                  color: Theme.of(context).colorScheme.inversePrimary),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.person),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtherProfilePage(uid: widget.post.uid),
                            ));
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtherProfilePage(uid: widget.post.uid),
                            ));
                      },
                      child: Text(
                        widget.post.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '@${widget.post.username}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () => _showOptions(),
                        icon: Icon(Icons.more_horiz))
                  ],
                ),
              ),
              Text(widget.post.message),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border),
              )
            ],
          ),
        ),
      ),
    );
  }
}
