import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/resources/firebase_services/storage.dart';
import 'package:instagram_clone/resources/model/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // Default image URL
  final String defaultImageUrl = 'https://i.stack.imgur.com/l60Hf.png';

  //SIGNUP
  Future<String> signUpUser({
    required String email,
    required String username,
    required String bio,
    required String password,
    required String confirmPassword,
    Uint8List? file,
  }) async {
    String res = "Some error occurred";
    String imageUrl;
    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty) {
        if (password != confirmPassword) {
          return "Password and Confirm Password didn't match.";
        }

        // Register user
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        if (file == null) {
          imageUrl = defaultImageUrl;
        } else {
          imageUrl =
              await StorageMethods().uploadImages('profilePics', false, file);
        }

        model.User user = model.User(
          uid: credentials.user!.uid,
          username: username,
          email: email,
          bio: bio,
          imageUrl: imageUrl,
          followers: [],
          following: [],
        );

        // Add user to database
        await _firestore.collection('users').doc(credentials.user!.uid).set(
              user.toJson(),
            );

        res = 'success';
      } else {
        res = 'Enter all the fields';
      }
    } on FirebaseException catch (err) {
      return err.message.toString();
    }
    return res;
  }

  //LOGIN
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Enter all the fields';
      }
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
    return res;
  }
}
