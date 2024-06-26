import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/explorer_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
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

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          const HomeScreen(),
          Center(child: Text('Search')),
          const ExplorerScreen(),
          Center(child: Text('reels')),
          Center(child: Text('Profile')),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          backgroundColor: primaryColor,
          currentIndex: _page,
          iconSize: 32.0,
          onTap: navigationTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: (_page == 0) ? blackColor : secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_page == 1) ? blackColor : secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                color: (_page == 2) ? blackColor : secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/Icons/instagram-reels-icon.png',
                height: 24.0,
                color: (_page == 3) ? blackColor : secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: (_page == 4) ? blackColor : secondaryColor,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
