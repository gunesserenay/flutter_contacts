import 'package:flutter/material.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactItem extends StatelessWidget {
  const ContactItem(
      {super.key, required this.contact, required this.onSelectedContact});

  final Contact contact;
  final void Function(Contact contact) onSelectedContact;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        child: InkWell(
          onTap: () {
            onSelectedContact(contact);
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: contact.profileImageUrl != null
                  ? NetworkImage(contact.profileImageUrl!)
                  : null,
              child: contact.profileImageUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(
              '${contact.firstName} ${contact.lastName}',
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              contact.phoneNumber,
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: const Color(0xFFBABABA),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
