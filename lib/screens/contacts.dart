import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/data/dummy_data.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/screens/contact_details.dart';
import 'package:flutter_contacts/screens/new_contact.dart';
import 'package:flutter_contacts/widgets/contact_item.dart';
import 'package:flutter_contacts/widgets/no_contacts_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> _contacts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    final url = Uri.parse('http://146.59.52.68:11235/api/User?skip=0&take=10');
    final headers = {
      'accept': 'text/plain',
      'ApiKey': '8d01e921-9d07-4a3e-a0f8-5dd6d2358259',
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<dynamic> users = body['data']['users'];
        List<Contact> contacts =
            users.map((dynamic item) => Contact.fromJson(item)).toList();
        setState(() {
          _contacts = contacts;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load contacts: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load contacts: $e';
      });
    }
  }

  void _openAddNewContactOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const AddNewContact());
  }

  void _selectContact(Contact contact) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ContactDetails(
              contact: contact,
            ));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : Expanded(
                child: ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) => ContactItem(
                    contact: _contacts[index],
                    onSelectedContact: (contact) {
                      _selectContact(contact);
                    },
                  ),
                ),
              );

    if (_contacts.isEmpty) {
      content = const NoContacts();
    }
    return Scaffold(
      backgroundColor: (const Color.fromARGB(255, 244, 244, 244)),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openAddNewContactOverlay,
            icon: const Icon(Icons.add),
          )
        ],
        backgroundColor: (const Color.fromARGB(255, 244, 244, 244)),
        centerTitle: false,
        title: Text(
          'Contacts',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          TextField(
            onChanged: (value) {},
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Search by name',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none, // Kenarlık yok
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          content
        ]),
      ),
    );
  }
}
