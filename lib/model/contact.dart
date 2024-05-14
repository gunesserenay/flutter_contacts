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

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
