import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String profileUrl;
  final List followers;
  final List following;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.profileUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'bio': bio,
        'profileUrl': profileUrl,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot['uid'],
      username: snapshot['username'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      profileUrl: snapshot['profileUrl'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
