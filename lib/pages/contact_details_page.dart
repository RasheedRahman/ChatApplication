import 'dart:io';

import 'package:contacts_app/contact_provider.dart';
import 'package:contacts_app/elements/round_image_widget.dart';
import 'package:contacts_app/pages/add_new_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../contact.dart';

class ContactDetailsPage extends StatelessWidget {
  ContactDetailsPage({super.key, required this.contact, required this.index});
  final Contact contact;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Popup menu button for actions
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                color: Color(0xFFFAFAFA),
                onSelected: (value) {
                  if (value == "edit") {
                    // Handle edit action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewContactPage(
                          text: "Edit contact",
                          contact: contact,
                        ),
                      ),
                    );
                  } else if (value == "delete") {
                    // Handle delete action
                    Provider.of<ContactProvider>(context, listen: false)
                        .removeContact(index);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.black,
                        content: Center(
                          child: Text(
                            "Contact Deleted Successfully",
                            style: TextStyle(
                                color: Colors.red, fontFamily: "Poppins"),
                          ),
                        )));
                    Navigator.pop(context);
                    // Implement your delete logic here
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: "edit",
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.green, fontFamily: "Poppins"),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "delete",
                      child: Text(
                        "Delete",
                        style:
                            TextStyle(color: Colors.red, fontFamily: "Poppins"),
                      ),
                    ),
                  ];
                },
              ),
              SizedBox(height: 50),
              Expanded(
                child: Column(
                  children: [
                    Column(
                      children: [
                        RoundImageWidget(
                          name: contact.name,
                          image: contact.image.isNotEmpty
                              ? FileImage(File(contact.image))
                              : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          contact.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ContactDetailsElement(
                      iconData: Icons.call,
                      field: contact.phoneNumber,
                      onTap: () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: contact.phoneNumber,
                        );
                        if (await canLaunchUrl(launchUri)) {
                          await launchUrl(launchUri);
                        } else {
                          throw 'Could not launch $contact.phoneNumber';
                        }
                      },
                    ),
                    ContactDetailsElement(
                      iconData: Icons.mail,
                      field: contact.email,
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: contact.email,
                        );

                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        } else {
                          throw 'Could not launch $emailUri';
                        }
                      },
                    ),
                    ContactDetailsElement(
                      iconData: Icons.calendar_month,
                      field: contact.birthday,
                    ),
                    ContactDetailsElement(
                      iconData: Icons.place,
                      field: contact.address,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactDetailsElement extends StatelessWidget {
  const ContactDetailsElement({
    super.key,
    required this.iconData,
    required this.field,
    this.onTap,
  });
  final IconData iconData;
  final String field;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return (field.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      iconData,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: 200, // Specify a width for the text container
                    child: Text(
                      field,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                      softWrap: true,
                      maxLines: 2, // Allows unlimited lines
                      overflow: TextOverflow
                          .clip, // Prevents overflowing the container
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox();
  }
}

// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => AddNewContactPage(
// text: "Edit contact",
// contact: contact,
// )));
