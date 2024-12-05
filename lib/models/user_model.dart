class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoURL;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'],
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photoURL: json['photoURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
    };
  }
}
