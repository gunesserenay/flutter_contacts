class Contact {
  final String firstName;
  final String? lastName;
  final String phoneNumber;
  final String profileImageUrl;

  const Contact(
      {required this.firstName,
      this.lastName,
      required this.phoneNumber,
      this.profileImageUrl = ''});
}
