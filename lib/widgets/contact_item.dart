import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, required this.contact});

  final Contact contact;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        leading: const Icon(
          Icons.face,
          size: 34,
        ),
        title: Text(
          '${contact.firstName} ${contact.lastName}',
          style: GoogleFonts.nunito(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          contact.phone,
          style: GoogleFonts.nunito(
              fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
