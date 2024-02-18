import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_community/models/user.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  createUser(Users user) async {
    await _db.collection('users').add(user.toJson());
  }

  Future<QuerySnapshot> findUsers(String bloodType) async {
    return await _db.collection('users').where('bgroup', isEqualTo: bloodType).get();
  }
}
