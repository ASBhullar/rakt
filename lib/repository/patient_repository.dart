import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donor_community/models/patient.dart';
import 'package:get/get.dart';

class PatientRepository extends GetxController {
  static PatientRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  createPatient(Patient patient) async {
    await _db.collection('patient').add(patient.toJson());
  }

  Future<void> updateStatus(String? patientId) async {
    if(patientId!.isEmpty) {
      return;
    }
    QuerySnapshot querySnapshot = await _db
        .collection('patient')
        .where('patientId', isEqualTo: patientId)
        .get();
    String? docId;
    for (var doc in querySnapshot.docs) {
      docId = doc.id;
      if((docId != null && !(docId.isEmpty))) {
        await _db.collection('patient').doc(docId).update({'status': false});
      }
    }
  }
}