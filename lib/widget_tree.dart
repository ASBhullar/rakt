import 'package:donor_community/about_us.dart';
import 'package:donor_community/welcome_page.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'login_page.dart'; // Import your LoggedInPage widget

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, // Assuming Auth is your authentication class
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LoggedInPage(); // Assuming you have a default constructor for LoggedInPage
        } else {
          return AboutUsPage();
        }
      },
    );
  }
}
