class CleanerModel {
  final String name;
  final String id;
  final String phone;
  final String experience;
  final double rating;
  final bool verified;
  final String imagePath;
  final String email;
  final String password;
  final String role; // 'cleaner'

  CleanerModel({
    required this.name,
    required this.id,
    required this.phone,
    required this.experience,
    required this.rating,
    required this.verified,
    required this.imagePath,
    required this.email,
    required this.password,
    this.role = 'cleaner',
  });
}
