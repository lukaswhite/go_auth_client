import "role.dart";

class User {
  final String uuid;
  final String username;
  final String name;
  final List<Role> roles;

  User({
    required this.uuid,
    required this.username,
    required this.name,
    this.roles = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    uuid: json['uuid'],
    username: json['username'],
    name: json['name'],
    roles: json['roles'] != null ? json['roles'].map((role) => Role.fromJson(role)).cast<Role>().toList() : [],
  );

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'name': name,
      'roles': roles.map((role) => role.toJson()).toList(),
    };
  }

  bool hasRole(String name) {
    return roles.where((role) => role.name == name).isNotEmpty;
  }

  bool hasAnyRole(List<String> names) {
    return roles.where((role) => names.contains(role.name)).isNotEmpty;
  }

  bool hasAllRoles(List<String> names) {
    return roles.where((role) => names.contains(role.name)).length == names.length;
  }

}