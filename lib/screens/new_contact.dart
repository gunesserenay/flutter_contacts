import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/widgets/new_contact_text_field.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  bool _isSaving = false;
  File? _imageFile;

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

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

  Future<void> _saveContact() async {
    if (_formkey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final phoneNumber = _phoneNumberController.text;

      setState(() {
        _isSaving = true;
      });
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
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
      final url = Uri.parse('http://146.59.52.68:11235/api/User');
      final headers = {
        'accept': 'text/plain',
        'ApiKey': '8d01e921-9d07-4a3e-a0f8-5dd6d2358259',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'profileImageUrl': imageUrl,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          Navigator.of(context).pop(true);
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      File? compressedFile = await _compressImage(file);
      setState(() {
        _imageFile = compressedFile;
      });
    }
  }

  Future<File?> _compressImage(File file) async {
    final directory = await getTemporaryDirectory();
    final targetPath = '${directory.path}/temp.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
      minWidth: 800,
      minHeight: 800,
    );

    if (result != null) {
      return File(result.path);
    } else {
      return null;
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

  @override
  Widget build(BuildContext context) {
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
                      Navigator.pop(context);
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
                  Text(
                    'New Contact',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _isSaving
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: _saveContact,
                          child: Text(
                            'Done',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFBABABA),
                            ),
                          )),
                ],
              ),
              Column(
                children: [
                  _imageFile == null
                      ? const Icon(
                          Icons.person,
                          size: 200,
                        )
                      : CircleAvatar(
                          radius: 100,
                          backgroundImage: FileImage(_imageFile!),
                        ),
                  TextButton(
                    onPressed: () => _showImageSourceActionSheet(context),
                    child: Text(
                      'Add Photo',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF000000),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
