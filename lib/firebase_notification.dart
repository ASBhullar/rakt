import 'package:donor_community/models/patient.dart';
import 'package:donor_community/repository/device_token_repository.dart';
import 'package:donor_community/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final userRepo = Get.put(DeviceTokensRepository());

  Future<String?> initTokens() async {
    final String? fCMToken = await _firebaseMessaging.getToken();
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? email = currentUser?.email != null ? currentUser?.email : '';
    await userRepo.updateTokens(email, fCMToken);
  }
}
