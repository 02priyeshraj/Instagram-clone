import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

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
                  const Icon(
                    Icons.favorite_border_outlined,
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
        ),
      ),
    );
  }
}
