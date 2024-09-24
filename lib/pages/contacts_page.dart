import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contact.dart';
import '../contact_provider.dart';
import 'add_new_contact_page.dart';
import 'contact_details_page.dart';
import '../elements/round_image_widget.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late ContactProvider contactProvider;

  @override
  void initState() {
    super.initState();
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    contactProvider
        .loadContacts(); // Load contacts when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contacts",
                style: TextStyle(fontFamily: "Poppins", fontSize: 20)),
            Expanded(
              child: Consumer<ContactProvider>(
                builder: (context, contactProvider, child) {
                  if (contactProvider.contactCount == 0) {
                    return Center(
                      child: Text(
                        "No Contacts Available",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: contactProvider.contactCount,
                    itemBuilder: (context, index) {
                      final contact = contactProvider.getContact(index);
                      return ContactItem(contact: contact, index: index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewContactPage(
                text: "Add new contact",
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final Contact contact;
  final int index;

  ContactItem({required this.contact, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onDoubleTap: () {
          Provider.of<ContactProvider>(context, listen: false)
              .removeContact(index);
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ContactDetailsPage(contact: contact, index: index),
            ),
          );
        },
        child: Row(
          children: [
            RoundImageWidget(
              isContactPage: true,
              name: contact.name,
              image: contact.image.isNotEmpty
                  ? FileImage(File(contact.image))
                  : null,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
                ),
                Text(
                  "+91 ${contact.phoneNumber}",
                  style: TextStyle(
                      fontSize: 15, fontFamily: "Poppins", color: Colors.grey),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
