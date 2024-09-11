import 'package:flutter/material.dart';
import 'package:twitter/services/auth/auth_service.dart';
import 'package:twitter/services/database/database_service.dart';

import '../../models/post.dart';
import '../../models/user.dart';

class DatabaseProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _db = DatabaseService();
  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // Save bio
  void saveBio(String bio, String uid) =>
      _db.saveBioInFirebase(bio: bio, uid: uid);

  //local list of posts
  List<Post> _allPosts = [];
  //get posts
  List<Post> get allPosts => _allPosts;

  //post message
  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);
    await loadAllPosts();
  }

  //delete the post
  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);
    await loadAllPosts();
  }

  // Get all posts
  Future<void> loadAllPosts() async {
    final allPosts = await _db.getPosts();

    //update local data
    _allPosts = allPosts;

    //initalize local like data
    initializeLikeMap();

    //update ui
    notifyListeners();
  }

  //Get user's posts
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  //local map to track like counts for each post
  Map<String, int> _likeCounts = {
    //for each post id : like count
  };

  // local list to track posts liked by current user
  List<String> _likedPosts = [];

  //does current user like this post ?
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);
  // get like count of a post
  int getLikeCount(String postId) => _likeCounts[postId]!;

  void initializeLikeMap() {
    // get current uid
    final currentUserUid = _auth.getCurrentUserUid();
    // for each post get like data
    for (var post in _allPosts) {
      _likeCounts[post.id] == post.likeCount;
      if (post.likedBy.contains(currentUserUid)) {
        _likedPosts.add(post.id);
      }
    }
  }

  Future<void> toggleLike(postId) async {
    /* burda local datayla çalışmak önemli çünkü aksi takdirde ui'da
     1 2 saniyelik bir gecikme olur ve biz bunu istemeyiz */
    //store original values in case it fails
    final likedPostsOriginal = _likedPosts;
    final likedCountsOriginal = _likeCounts;

    //perform like / unlike
    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }
  }
}
