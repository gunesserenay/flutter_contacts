class Contact {
  final String firstName;
  final String lastName;
  final String phone;
  final String avatarUrl;

  const Contact(
      {required this.firstName,
      required this.lastName,
      required this.phone,
      this.avatarUrl = ''});
}
