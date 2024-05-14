import 'package:flutter/material.dart';
import 'package:flutter_contacts/screens/new_contact.dart';
import 'package:google_fonts/google_fonts.dart';

class NoContacts extends StatelessWidget {
  const NoContacts({super.key});

  void _openAddNewContactOverlay(BuildContext context) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const AddNewContact());
  }

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
            style:
                GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              _openAddNewContactOverlay(context);
            },
            child: Text(
              'Create New Contact',
              textAlign: TextAlign.start,
              style: GoogleFonts.nunito(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
