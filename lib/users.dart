class Users {
  final String id;
  final String name;
  final String username;
  final String email;
  final String phoneNumber;
  final String profilePicture;

  Users(
    this.id,
    this.email, {
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.profilePicture,
  });
}
