import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/add_reels_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int idx) {
    pageController.jumpToPage(idx);
  }

  void onPageChanged(int idx) {
    setState(() {
      _currentIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: const [
                AddPostScreen(),
                AddReelsScreen(),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(
                milliseconds: 300,
              ),
              bottom: 10.0,
              right: _currentIndex == 0 ? 100.0 : 150.0,
              child: Container(
                width: 120.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigationTapped(0);
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: _currentIndex == 0
                              ? primaryColor
                              : secondaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigationTapped(1);
                      },
                      child: Text(
                        'Reels',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: _currentIndex == 1
                              ? primaryColor
                              : secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
