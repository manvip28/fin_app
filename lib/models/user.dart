// lib/models/user.dart
class User {
  final String uid;
  final String email;
  final String displayName;
  final DateTime lastSynced;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.lastSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'lastSynced': lastSynced.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      lastSynced: DateTime.parse(map['lastSynced']),
    );
  }
}