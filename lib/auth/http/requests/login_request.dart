class LoginRequest {
  String? username;
  String? password;

  LoginRequest({
    this.username,
    this.password,
  });

  factory LoginRequest.fromMap(Map<String, Object?> map) => LoginRequest(
    username: map['username'] as String,
    password: map['password'] as String,
  );

  Map<String, String> toJson() {
    return {
      'username': username ?? '',
      'password': password ?? '',
    };
  }
}