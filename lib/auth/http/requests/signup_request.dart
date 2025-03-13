class SignupRequest {
  String? username;
  String? name;
  String? password;

  SignupRequest({
    this.username,
    this.name,
    this.password,
  });

  factory SignupRequest.fromMap(Map<String, Object?> map) => SignupRequest(
    username: map['username'] as String,
    name: map['name'] as String,
    password: map['password'] as String,
  );

  Map<String, String> toJson() {
    return {
      'username': username ?? '',
      'name': name ?? '',
      'password': password ?? '',
    };
  }
}