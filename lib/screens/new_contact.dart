import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/widgets/new_contact_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  Future<void> _saveContact() async {
    if (_formkey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final phoneNumber = _phoneNumberController.text;
      final profileImageUrl = 'assets/images/camera.png';

      final url = Uri.parse('http://146.59.52.68:11235/api/User');
      final headers = {
        'Content-Type': 'application/json',
        'ApiKey': '49fbc414-78fb-4fd4-953d-be210be2a829',
      };

      final body = json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'profileImageUrl': profileImageUrl,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact added succesfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the blanks')),
      );
    }
  }

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
                    Text(
                      'New Contact',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: _saveContact,
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
                Column(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 200,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Add Photo',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            NewContactTextField(
                              hint: 'First name',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length <= 1 ||
                                    value.trim().length > 50) {
                                  return 'Must be between 1 and 50 characters';
                                }
                                return null;
                              },
                              controller: _firstNameController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            NewContactTextField(
                              hint: 'Last name',
                              controller: _lastNameController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            NewContactTextField(
                              hint: 'Phone',
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                } else if (!RegExp(r'^[0-9]+$')
                                    .hasMatch(value)) {
                                  return 'Phone number must be numeric';
                                }
                                return null;
                              },
                              controller: _phoneNumberController,
                            ),
                          ],
                        ))
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
