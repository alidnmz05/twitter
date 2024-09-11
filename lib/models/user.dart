/*

  USER PROFILE

  This is what every user should have for their profile.

-------------------------------------------------------------------------
    - uid
    - name
    - email
    - username
    - bio
    - profile photo

 */

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;
  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.bio,
  });
  //Convert firestore document to a user profile
  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      username: data['username'],
      bio: data['bio'],
    );
  }
  //convert map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
    };
  }
}
