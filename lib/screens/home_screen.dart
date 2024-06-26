import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0.0,
            centerTitle: true,
            leading: const Icon(Icons.camera_alt_outlined),
            title: SizedBox(
              width: 105.0,
              height: 36.0,
              child: Image.asset('assets/Logo/instagram.jpg'),
            ),
            actions: [
              Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Image.asset(
                    'assets/Icons/messenger.png',
                    color: blackColor,
                    height: 24.0,
                    width: 24.0,
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                    child: Transform.rotate(
                      angle: -0.7,
                      child: const Icon(
                        Icons.send,
                        color: blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
