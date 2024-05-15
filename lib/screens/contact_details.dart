import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/data/dummy_data.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/widgets/new_contact_text_field.dart';
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
  bool _isEditing = false;
  bool _isSaving = false;

  String _firstName = '';
  String? _lastName;
  String _phoneNumber = '';

  final _formkey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  @override
  void initState() {
    super.initState();

    _firstNameController =
        TextEditingController(text: widget.contact.firstName);
    _lastNameController = TextEditingController(text: widget.contact.lastName);
    _phoneNumberController =
        TextEditingController(text: widget.contact.phoneNumber);

    _firstName = widget.contact.firstName;
    _lastName = widget.contact.lastName;
    _phoneNumber = widget.contact.phoneNumber;
  }

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

  Future<void> _updateContact() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final updatedContact = widget.contact.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
      );

      final url =
          Uri.parse('http://146.59.52.68:11235/api/User/${widget.contact.id}');
      final headers = {
        'accept': 'text/plain',
        'ApiKey': '8d01e921-9d07-4a3e-a0f8-5dd6d2358259',
        'Content-Type': 'application/json',
      };
      final body = json.encode({
        'firstName': updatedContact.firstName,
        'lastName': updatedContact.lastName,
        'phoneNumber': updatedContact.phoneNumber,
        'profileImageUrl': updatedContact.profileImageUrl,
      });

      try {
        final response = await http.put(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          setState(() {
            _firstName = _firstNameController.text;
            _lastName = _lastNameController.text;
            _phoneNumber = _phoneNumberController.text;
            _isEditing = false;
            _isSaving = false;
          });
        } else {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
                    Navigator.of(context).pop(true);
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
                  onPressed: () {
                    if (_isEditing) {
                      _updateContact();
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  child: Text(
                    !_isEditing ? 'Edit' : 'Done',
                    style: !_isEditing
                        ? GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue)
                        : GoogleFonts.nunito(
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
                    'Change Photo',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (_isEditing)
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
                              } else if (!RegExp(r'^\+?[0-9]+$')
                                  .hasMatch(value)) {
                                return 'Phone number must be numeric';
                              }
                              return null;
                            },
                            controller: _phoneNumberController,
                          ),
                        ],
                      ))
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _firstName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(
                        height: 30,
                      ),
                      Text(
                        _lastName!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(
                        height: 30,
                      ),
                      Text(
                        _phoneNumber,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(
                        height: 30,
                      ),
                      _isDeleting
                          ? const CircularProgressIndicator()
                          : InkWell(
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
