

class AppUser {
  final String u_name;
  final String email;

  AppUser({required this.u_name, required this.email});

  // Convert from Firestore Document
  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      u_name: data['username'] ?? '',
      email: data['email'] ?? '',
    );
  }

  // Convert to Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'u_name': u_name,
      'email': email,
    };
  }
}
