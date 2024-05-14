import 'package:flutter/material.dart';
import 'package:flutter_contacts/data/dummy_data.dart';
import 'package:flutter_contacts/model/contact.dart';
import 'package:flutter_contacts/widgets/contact_item.dart';
import 'package:flutter_contacts/widgets/no_contacts_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  final List<Contact> _contacts = contacts;

  @override
  Widget build(BuildContext context) {
    Widget content = Expanded(
      child: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) => ContactItem(contact: _contacts[index]),
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
              onPressed: () {},
              icon: Image.asset(
                'assets/images/add.png',
                width: 25,
                height: 25,
              ))
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
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search)),
          ),
          content
        ]),
      ),
    );
  }
}
