
class Users {
  final String? id;
  final String? username;
  final String? lat;
  final String? lng;
  final String? bgroup;

  const Users(
      {this.id,
      required this.username,
      required this.lat,
      required this.lng,
      required this.bgroup});

  toJson() {
    return {
      "username": username,
      "lat": lat,
      "lng": lng,
      "bgroup": bgroup
    };
  }
}
