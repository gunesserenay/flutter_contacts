import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoContacts extends StatelessWidget {
  const NoContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 60,
          ),
          Text(
            'No Contacts',
            style:
                GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Contacts you’ve added will appear here.',
            style: GoogleFonts.nunito(fontSize: 16),
          ),
          Text(
            'Create New Contact',
            style: GoogleFonts.nunito(
                color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
