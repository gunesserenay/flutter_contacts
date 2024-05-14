import 'package:flutter/material.dart';
import 'package:flutter_contacts/widgets/new_contact_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
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
                      onPressed: () {},
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Text(
                      'New Contact',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Done',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const Column(
                  children: [
                    Icon(
                      Icons.person,
                      size: 200,
                    ),
                    NewContactTextField(hint: 'First name'),
                    SizedBox(
                      height: 20,
                    ),
                    NewContactTextField(hint: 'Last name'),
                    SizedBox(
                      height: 20,
                    ),
                    NewContactTextField(
                      hint: 'Phone',
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
