import 'package:flutter/material.dart';
import 'package:flutter_contacts/data/dummy_data.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Edit',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Icon(
                  Icons.person,
                  size: 200,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Change Photo',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.firstName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    Text(
                      contact.lastName!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    Text(
                      contact.phoneNumber,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Delete contact',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
