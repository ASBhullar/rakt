import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_community/models/patient.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../repository/device_token_repository.dart';
import '../repository/user_repository.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final userRepo = Get.put(UserRepository());
  final deviceTokenRepo = Get.put(DeviceTokensRepository());

  Future<void> findDonors(String? bloodType, double? latitude, double? longitude, Patient patient) async {
    if(bloodType == null || latitude==null || longitude==null) {
      return;
    }
    try {
      // Fetch users with blood type "B+"
      QuerySnapshot userSnapshot = await userRepo.findUsers(bloodType);
      List<String> allUserTokens = [];

      // Iterate through users and check if they are within 50 miles
      for (var doc in userSnapshot.docs) {
        double userLat = double.parse(doc.get('lat'));
        double userLng = double.parse(doc.get('lng'));
        double distanceInMeters = Geolocator.distanceBetween(latitude, longitude, userLat, userLng);

        if (distanceInMeters / 1609.34 <= 50) { // Convert meters to miles and check if within 50 miles
          // Fetch device token from a different table (assuming table name is 'device_tokens' and there's a 'token' field)
          String username = doc.get('username');
          List<String> deviceTokens = await deviceTokenRepo.findUserTokens(username);
          allUserTokens.addAll(deviceTokens);

          // Send FCM notification
        }
      }
      await pushNotificationToDevices(allUserTokens, patient);
    } catch (e) {
      print('Error sending notifications: $e');
    }
  }

  Future<void> pushNotificationToDevices(List<String> allUserTokens, Patient patient) async {
    final Uri fcmUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

    for(String token in allUserTokens) {
      final response = await http.post(
        fcmUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=',
        },
        body: jsonEncode({
          'notification': {
            'title': 'Urgent Blood Required',
            'body': patient.institutionName,
          },
          'priority': 'high',
          'data': patient.toJson(),
          'to': token,
        }),
      );
      print('');
      print('');
      print(response.statusCode);
      print('');
      print('');
    }
  }
}
