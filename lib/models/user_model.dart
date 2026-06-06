class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role; // 'user' atau 'cleaner'

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.role = 'user',
  });
}
