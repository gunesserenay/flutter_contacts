class Contact {
  final String id;
  final String firstName;
  final String? lastName;
  final String phoneNumber;
  final String profileImageUrl;

  const Contact(
      {required this.id,
      required this.firstName,
      this.lastName,
      required this.phoneNumber,
      this.profileImageUrl = ''});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
