class UserModel {
  final String? id;
  final String fullname;
  final String email;
  final String mobile;
  final String role;

  const UserModel({
    this.id,
    required this.fullname,
    required this.email,
    required this.mobile,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullname": fullname,
      "email": email,
      "mobile": mobile,
      "role": role,
    };
  }
}
