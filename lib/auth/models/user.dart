class User {
  final String uuid;
  final String username;
  final String name;

  User({
    required this.uuid,
    required this.username,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    uuid: json['uuid'],
    username: json['username'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'name': name,
    };
  }

}