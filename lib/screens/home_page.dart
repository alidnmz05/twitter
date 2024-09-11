import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/my_post_tile.dart';

import '../components/my_drawer.dart';
import '../components/my_input_alert_box.dart';
import '../models/post.dart';
import '../services/database/database_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Post text field controller
  final TextEditingController messageController = TextEditingController();

  // Provider for database operations
  late final DatabaseProvider dataBaseProvider;

  @override
  void initState() {
    super.initState();
    // Initialize provider
    dataBaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    await dataBaseProvider.loadAllPosts();
    // Ensure UI is updated after loading posts
    setState(() {});
  }

  void _showEditPost() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        title: 'Post Edit',
        hintText: "Bir gönderi gir...",
        onPressedText: 'Onayla',
        textController: messageController,
        onPressed: () async {
          // Post the message and clear the controller
          await postMessage(messageController.text);
          messageController.clear();
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> postMessage(String message) async {
    await dataBaseProvider.postMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final listeningProvider = Provider.of<DatabaseProvider>(context);
    final allPosts = listeningProvider.allPosts;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'H O M E',
            style: TextStyle(color: Theme.of(context).primaryColor),
          )),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEditPost,
        child: const Icon(Icons.add),
      ),
      body: _buildPostList(allPosts),
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ? const Center(child: Text("Gönderi yok"))
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return MyPostTile(
                post: post,
              );
            },
          );
  }
}
