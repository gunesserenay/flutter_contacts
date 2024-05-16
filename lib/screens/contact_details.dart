import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/widgets/new_contact_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
  File? _newImageFile;

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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
        _isEditing = true;
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
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

  void _showDeleteConfirmationPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Delete Account?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF0000))),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  side: const WidgetStatePropertyAll<BorderSide>(
                      BorderSide(color: Color(0xFFBABABA))),
                  backgroundColor:
                      const WidgetStatePropertyAll<Color>(Color(0xFFF4F4F4)),
                  padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.all(10)),
                  shape: WidgetStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                onPressed: () {
                  _deleteContact();
                  Navigator.of(context).pop();
                },
                child: Text('Yes',
                    style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF000000))),
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  side: const WidgetStatePropertyAll<BorderSide>(
                      BorderSide(color: Color(0xFFBABABA))),
                  backgroundColor:
                      const WidgetStatePropertyAll<Color>(Color(0xFFF4F4F4)),
                  padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.all(10)),
                  shape: WidgetStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000)),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  Future<String?> _uploadImage(File imageFile) async {
    final url = Uri.parse('http://146.59.52.68:11235/api/User/UploadImage');
    final headers = {
      'accept': 'application/json',
      'ApiKey': '8d01e921-9d07-4a3e-a0f8-5dd6d2358259',
    };

    try {
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody);
        return decodedResponse['data']['imageUrl'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _updateContact() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });
      String? imageUrl;
      if (_newImageFile != null) {
        imageUrl = await _uploadImage(_newImageFile!);
        if (imageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error uploading image')),
          );
          setState(() {
            _isSaving = false;
          });
          return;
        }
      }
      final updatedContact = widget.contact.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        profileImageUrl: imageUrl,
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
    ImageProvider<Object>? backgroundImage;
    if (_newImageFile != null) {
      backgroundImage = FileImage(_newImageFile!);
    } else if (widget.contact.profileImageUrl != null) {
      backgroundImage = NetworkImage(widget.contact.profileImageUrl!);
    }
    Widget editContent = Form(
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
                } else if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
                  return 'Phone number must be numeric';
                }
                return null;
              },
              controller: _phoneNumberController,
            ),
          ],
        ));
    return DecoratedBox(
      decoration: const BoxDecoration(
          color: Color(0xFFF4F4F4),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: SizedBox(
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
                        color: const Color(0xFF0075FF),
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
                    child: _isSaving
                        ? const CircularProgressIndicator()
                        : Text(
                            !_isEditing ? 'Edit' : 'Done',
                            style: !_isEditing
                                ? GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: const Color(0xFF0075FF))
                                : GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: const Color(0xFFBABABA)),
                          ),
                  ),
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: backgroundImage,
                    child: (_newImageFile == null &&
                            widget.contact.profileImageUrl == null)
                        ? const Icon(Icons.person, size: 200)
                        : null,
                  ),
                  TextButton(
                    onPressed: () => _showImageSourceActionSheet(context),
                    child: Text(
                      'Change Photo',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                  if (_isEditing)
                    editContent
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
                                onTap: () =>
                                    _showDeleteConfirmationPopup(context),
                                child: Text(
                                  'Delete contact',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: const Color(0xFFFF0000),
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
      ),
    );
  }
}
