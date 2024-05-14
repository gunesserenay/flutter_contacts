import 'package:flutter/material.dart';
import 'package:flutter_contacts/data/dummy_data.dart';
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
        color: Colors.white,
        elevation: 0,
        child: InkWell(
          onTap: () {
            onSelectedContact(contact);
          },
          child: ListTile(
            leading: const Icon(
              Icons.face,
              size: 34,
            ),
            title: Text(
              '${contact.firstName} ${contact.lastName}',
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              contact.phoneNumber,
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
