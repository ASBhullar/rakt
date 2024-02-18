
class Patient {
  final String? patientId;
  final String? patientName;
  final String? institutionName;
  final String? address;
  final String? bgroup;
  final bool isActive;

  const Patient(
      {required this.patientId,
        required this.patientName,
        required this.institutionName,
        required this.address,
        required this.isActive,
        required this.bgroup});

  toJson() {
    return {
      "patientId": patientId,
      "patientName": patientName,
      "institutionName": institutionName,
      "address": address,
      "isActive": isActive,
      "bgroup": bgroup
    };
  }

  static Patient fromMap(Map<String, dynamic> map) {
    return Patient(
      patientId: map['patientId'] as String,
      patientName: map['patientName'] as String,
      institutionName: map['institutionName'] as String,
      address: map['address'] as String,
      isActive: map['isActive'] as bool,
      bgroup: map['bgroup'] as String,
    );
  }
}
