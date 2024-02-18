import 'package:donor_community/firebase_notification.dart';
import 'package:donor_community/welcome_page.dart';
import 'package:donor_community/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/patient.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  runApp(const MyApp());
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  Patient patient = Patient.fromMap(message.data);
  print(patient.patientName);
  navigatorKey.currentState?.pushReplacement(
    MaterialPageRoute(builder: (context) => LoggedInPage()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: WidgetTree(), // Set WidgetTree as the home widget
    );
  }
}
