import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/widgets/no_contacts_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    var a = 1;

    Widget content = const NoContacts();
    if (a == 1) {
      content = Expanded(
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) => Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ListTile(
              leading: const Icon(
                Icons.face,
                size: 34,
              ),
              title: Text(
                'Alice Wellington',
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '+1234567890',
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: (const Color.fromARGB(255, 244, 244, 244)),
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        backgroundColor: (const Color.fromARGB(255, 244, 244, 244)),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Contacts',
            style:
                GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextField(
            onChanged: (value) {},
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search)),
          ),
        ),
        content
      ]),
    );
  }
}
