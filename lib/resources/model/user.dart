class User {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String imageUrl;
  final List followers;
  final List following;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.imageUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'bio': bio,
        'imageUrl': imageUrl,
        'followers': followers,
        'following': following,
      };
}
