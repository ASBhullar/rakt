import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_community/models/device_token.dart';
import 'package:get/get.dart';

class DeviceTokensRepository extends GetxController {
  static DeviceTokensRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  addToken(DeviceToken deviceToken) async {
    await _db.collection('device_tokens').add(deviceToken.toJson());
  }

  Future<void> updateTokens(String? username, String? token) async {
    if(username!.isEmpty) {
      return;
    }
    QuerySnapshot querySnapshot = await _db
        .collection('device_tokens')
        .where('username', isEqualTo: username)
        .get();
    String? docId;
    List<String> tokens = [];
    for (var doc in querySnapshot.docs) {
      DeviceToken deviceToken = fromJson(doc.data() as Map<String, dynamic>);
      tokens.addAll(deviceToken.tokens);
      docId = doc.id;
    }
    if((docId == null || docId.isEmpty) && (token != null && !token.isEmpty)) {
      DeviceToken deviceToken = new DeviceToken(username: username, tokens: [token]);
      addToken(deviceToken);
    } else if ((token != null && !token.isEmpty) && !tokens.contains(token)) {
      tokens.add(token);
      await _db.collection('device_tokens').doc(docId).update({'tokens': tokens});
    }
  }

  Future<List<String>> findUserTokens(String username) async {
    QuerySnapshot querySnapshot = await _db
        .collection('device_tokens')
        .where('username', isEqualTo: username)
        .get();

    List<String> tokens = [];
    for (var doc in querySnapshot.docs) {
      DeviceToken deviceToken = fromJson(doc.data() as Map<String, dynamic>);
      tokens.addAll(deviceToken.tokens);
    }
    return tokens;
  }

  static DeviceToken fromJson(Map<String, dynamic> json) {
    return DeviceToken(
      username: json['username'],
      tokens: List<String>.from(json['tokens']),
    );
  }

}