
class Donation {
  final String? username;
  final String? institutionName;
  final String? address;
  final String? date;

  const Donation({
        required this.username,
        required this.institutionName,
        required this.address,
        required this.date});

  toJson() {
    return {
      "username": username,
      "institutionName": institutionName,
      "address": address,
      "date": date
    };
  }
}
