import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/global_var.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileSreenLayout;
  const ResponsiveLayout({
    super.key,
    required this.webScreenLayout,
    required this.mobileSreenLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constaints) {
        if (constaints.maxWidth > webScreenSize) {
          return webScreenLayout;
        }
        return mobileSreenLayout;
      },
    );
  }
}
