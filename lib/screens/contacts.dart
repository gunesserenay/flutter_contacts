import 'dart:convert';
import 'package:flutter/material.dart';
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
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.firstName.toLowerCase().contains(query) ||
            contact.lastName?.toLowerCase().contains(query) == true;
      }).toList();
    });
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
          _filteredContacts = contacts;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load contacts')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load contacts')),
        );
      }
    }
  }

  Future<void> _openAddNewContactOverlay() async {
    final result = await showModalBottomSheet<bool>(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const AddNewContact());
    if (result == true) {
      _getContacts();
    }
  }

  Future<void> _selectContact(Contact contact) async {
    final result = await showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ContactDetails(
              contact: contact,
            ));

    if (result == true) {
      _getContacts();
    }
    if (result != null) {
      setState(() {
        int index = _contacts.indexWhere((x) => x.id == result.id);
        if (index != -1) {
          _contacts[index] = result;
        }
        _filterContacts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) => ContactItem(
                contact: _filteredContacts[index],
                onSelectedContact: (contact) {
                  _selectContact(contact);
                },
              ),
            ),
          );

    if (_contacts.isEmpty) {
      content = NoContacts(
        addNewContact: _openAddNewContactOverlay,
      );
    }
    return Scaffold(
      backgroundColor: (const Color(0xFFF4F4F4)),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openAddNewContactOverlay,
            icon: const Icon(Icons.add),
          )
        ],
        backgroundColor: (const Color(0xFFF4F4F4)),
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
            controller: _searchController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Search by name',
              hintStyle: GoogleFonts.nunito(
                  fontSize: 16,
                  color: const Color(0xFFBABABA),
                  fontWeight: FontWeight.bold),
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: const Color(0xFFBABABA),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
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
