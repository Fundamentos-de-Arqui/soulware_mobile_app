class AuthTokens {
  final int id;
  final String accountType; // 'LEGAL_RESPONSIBLE' | 'THERAPIST'
  final String token;
  final String message;
  final int profileId;


  AuthTokens({required this.id, required this.accountType, required this.token, required this.message, required this.profileId});

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        id: json['id'],
        accountType: json['accountType'],
        token: json['token'],
        message: json['message'],
        profileId: json['profileId'],
      );
}
