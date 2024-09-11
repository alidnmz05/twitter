import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/components/my_input_alert_box.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/services/auth/auth_service.dart';
import 'package:twitter/services/database/database_provider.dart';

import '../components/my_post_tile.dart';
import '../models/post.dart';

/*
  This is a profile page for a given uid
*/
class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Providers
  late final dataBaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // User info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUserUid();
  bool _isLoading = true;

  // Bio controller
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      user = await dataBaseProvider.userProfile(widget.uid);
    } catch (e) {
      // Handle errors if necessary
      print("Error loading user: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        title: 'Bio Edit',
        hintText: "Bir biyografi gir...",
        onPressedText: 'Onayla',
        textController: bioController,
        onPressed: () {
          dataBaseProvider.saveBio(bioController.text, widget.uid);
          Navigator.pop(context);
          loadUser();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listeningProvider = Provider.of<DatabaseProvider>(context);
    final userPosts = listeningProvider.filterUserPosts(widget.uid);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _isLoading ? "Yükleniyor.." : (user?.name ?? "Kullanıcı Adı"),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("@${user?.username ?? 'Kullanıcı Adı'}"),
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 90,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Text(
                          "Bio",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _showEditBioBox(),
                          icon: Icon(
                            Icons.settings,
                            color: Theme.of(context).colorScheme.primary,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(25),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          user?.bio.isEmpty ?? true
                              ? "Boş Biyografi.."
                              : "${user!.bio}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gönderiler",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildPostList(userPosts),
                  ),
                ],
              ),
            ),
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
