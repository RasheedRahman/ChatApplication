import 'dart:io';
import 'package:contacts_app/elements/custom_text_field.dart';
import 'package:contacts_app/pages/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../contact.dart';
import '../contact_provider.dart';
import '../elements/round_image_widget.dart';

class AddNewContactPage extends StatelessWidget {
  AddNewContactPage({super.key, required this.text, this.contact});
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String text;
  final Contact? contact;
  bool isOpen = false;
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Selected date color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // Button text color
              ),
            ),
            dialogBackgroundColor: Colors.white,
            // Add more customizations if necessary
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      birthdayController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (text == "Edit contact") {
      nameController.text = contact?.name ?? "";
      phoneNumberController.text = contact?.phoneNumber ?? "";
      emailController.text = contact?.email ?? "";
      birthdayController.text = contact?.birthday ?? "";
      addressController.text = contact?.address ?? "";
    }
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: SvgPicture.asset("assets/Close.svg"),
                    onTap: () {
                      isOpen = false;
                      Navigator.pop(context);
                      Provider.of<ContactProvider>(context, listen: false)
                          .resetImage();
                    },
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        color: Colors.grey),
                  ),
                  GestureDetector(
                      onTap: () {
                        isOpen = false;
                        if (_formKey.currentState!.validate()) {
                          Contact newContact = Contact(
                            name: nameController.text,
                            phoneNumber: phoneNumberController.text,
                            email: emailController.text,
                            birthday: birthdayController.text,
                            address: addressController.text,
                            image: Provider.of<ContactProvider>(context,
                                        listen: false)
                                    .image
                                    ?.path ??
                                contact?.image ??
                                "",
                          );
                          text == "Edit contact"
                              ? Provider.of<ContactProvider>(context,
                                      listen: false)
                                  .deleteRepeat(phoneNumberController.text)
                              : null;
                          Provider.of<ContactProvider>(context, listen: false)
                              .addContact(
                                  newContact, phoneNumberController.text);
                          text == "Edit contact"
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContactsPage()))
                              : Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.black,
                              content: Center(
                                child: Text(
                                  text != "Edit contact"
                                      ? 'Contact Saved Successfully'
                                      : "Contact Edited Successfully",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: "Poppins"),
                                ),
                              )));
                        }
                      },
                      child: SvgPicture.asset("assets/tickk.svg")),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  child: Provider.of<ContactProvider>(context).image == null &&
                          (contact?.image.isEmpty ?? true)
                      ? SvgPicture.asset(
                          'assets/add_image.svg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : RoundImageWidget(
                          image: FileImage(text == "Edit contact" &&
                                  isOpen == false
                              ? File(contact!.image)
                              : Provider.of<ContactProvider>(context).image!),
                          name: contact?.name ?? ""),
                  onTap: () async {
                    isOpen = true;
                    await Provider.of<ContactProvider>(context, listen: false)
                        .pickImage();
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset("assets/user.svg"),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      controller: nameController,
                      hintText: "Name",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset("assets/call.svg"),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextField(
                      // isEditPage: text == "Edit contact" ? true : false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a mobile number';
                        }
                        if (value.length < 10) {
                          return 'Mobile number should be 10 characters';
                        }
                        return null;
                      },
                      controller: phoneNumberController,
                      isNumber: true,
                      hintText: "Phone Number",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset("assets/sms.svg"),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        final emailRegExp = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      hintText: "Email",
                      controller: emailController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset("assets/calendar.svg"),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Birthday",
                      controller: birthdayController,
                      isCalender: true,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset("assets/location.svg"),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Address",
                      controller: addressController,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
