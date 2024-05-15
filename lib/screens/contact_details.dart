import 'package:flutter/material.dart';
import 'package:flutter_contacts/data/dummy_data.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ContactDetails extends StatefulWidget {
  const ContactDetails({super.key, required this.contact});

  final Contact contact;

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  bool _isDeleting = false;

  Future<void> _deleteContact() async {
    setState(() {
      _isDeleting = true;
    });
    final url =
        Uri.parse('http://146.59.52.68:11235/api/User/${widget.contact.id}');
    final headers = {
      'accept': 'text/plain',
      'ApiKey': '8d01e921-9d07-4a3e-a0f8-5dd6d2358259',
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted!')),
        );
      } else {
        setState(() {
          _isDeleting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isDeleting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

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
                      widget.contact.firstName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    Text(
                      widget.contact.lastName!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    Text(
                      widget.contact.phoneNumber,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    InkWell(
                      onTap: _deleteContact,
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
