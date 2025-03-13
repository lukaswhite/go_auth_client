class Token {
  final String token;
  final DateTime expires;

  Token({
    required this.token,
    required this.expires,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    token: json['token'],
    expires: DateTime.fromMillisecondsSinceEpoch(json['expires'] * 1000),
  );

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expires': expires.millisecondsSinceEpoch / 1000,
    };
  }

  bool get hasExpired {
    return expires.isBefore(DateTime.now());
  }

  int get minutesBeforeExpires {
    return DateTime.now().difference(expires).inMinutes;
  }
}