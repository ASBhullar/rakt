import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_community/models/donation.dart';
import 'package:donor_community/models/user.dart';
import 'package:get/get.dart';

class DonationRepository extends GetxController {
  static DonationRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  createUser(Donation donation) async {
    await _db.collection('donation').add(donation.toJson());
  }

  Future<QuerySnapshot> findDonations(String username) async {
    return await _db.collection('donation').where('username', isEqualTo: username).get();
  }
}
