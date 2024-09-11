/*
  -User Profile
  -Post Message
  -Likes
  -Comments
  -report/block/delete account
  -search users


*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter/models/post.dart';
import 'package:twitter/models/user.dart';

class DatabaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  //------------------------------------------------------------------------------------------------------------------
  //When a new user registers, we create an account for them and we are save and we want show the in him profile
  //Save user info
  Future<void> saveUserInfoInFirebase({required String name, email}) async {
    //get current uid
    String uid = _auth.currentUser!.uid;
    String username = email.split('@')[0];
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );
    //convert to map
    final userMap = user.toMap();
    await _db.collection("Users").doc(uid).set(userMap);
  }

  Future<void> saveBioInFirebase({required String bio, uid}) async {
    String uid = _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({'bio': bio});
  }

  //get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();
      //convert map to UserProfile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //--------------------------------------------------------------------------------------------------------------

  //post a message
  Future<void> postMessageInFirebase(String message) async {
    try {
      //get uid
      String uid = _auth.currentUser!.uid;
      // use uid and get profile
      UserProfile? user = await getUserFromFirebase(uid);
      Post newPost = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user!.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );
      //Convert to map object for firebase
      Map<String, dynamic> newPostMap = newPost.toMap();
      //add to firebase
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc()
          .set(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  //delete a post
  Future<void> deletePostFromFirebase(String postId) async {
    await _db.collection("Posts").doc(postId).delete();
    try {} catch (e) {
      print(e);
    }
  }

  //get all posts
  Future<List<Post>> getPosts() async {
    try {
      // "posts" koleksiyonundaki tüm dökümanları çekiyoruz
      QuerySnapshot snapshot = await _db
          .collection('Posts')
          .orderBy('timestamp', descending: true)
          .get();
      //return as a list of post
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print("Error getting posts: $e");
      return [];
    }
  }

  //toggle like count
  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      //get current uid
      String uid = _auth.currentUser!.uid;
      //go to doc for this post
      DocumentReference docRef = _db.collection("Posts").doc(postId);

      //execute like
      await _db.runTransaction(
        (transaction) async {
          //get post data
          DocumentSnapshot postSnapshot = await transaction.get(docRef);

          //get like of users who like this post
          List<String> likedBy =
              List<String>.from(postSnapshot['likedBy'] ?? []);
          //get like count
          int currentLikeCount = postSnapshot['likeCount'];

          //if user has not liked this post yet -> then like
          if (!likedBy.contains(uid)) {
            // add user to like list
            likedBy.add(uid);
            //increment like count
            currentLikeCount++;
          }

          //if user has already liked this post -> then unlike
          else {
            //remove user from like list
            likedBy.remove(uid);
            //decrease like count
            currentLikeCount--;
          }
          transaction.update(docRef, {
            'likeCount': currentLikeCount,
            'likedBy': likedBy,
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
