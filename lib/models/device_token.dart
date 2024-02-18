class DeviceToken {
  final String? id;
  final String username;
  final List<String> tokens;

  const DeviceToken({
    this.id,
    required this.username,
    required this.tokens,
  });

  toJson() {
    return {"username": username, "tokens": tokens};
  }
}
