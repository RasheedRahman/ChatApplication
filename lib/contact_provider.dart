import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contact.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  File? _image;

  // Getter for the contact list
  List<Contact> get contacts => _contacts;

  File? get image => _image;

  // Add a contact to the list and persist to SharedPreferences
  void addContact(Contact contact, String phoneNumber) {
    // Check if the phone number already exists in the contact list
    for (int i = 0; i < _contacts.length; i++) {
      if (_contacts[i].phoneNumber == phoneNumber) {
        print("Phone Number Already Exists");
        return;
      }
    }

    _contacts.add(contact);
    resetImage();
    _saveContacts(); // Persist the updated list
    notifyListeners(); // Notify the UI that the data has changed
  }

  // Update a contact in the list and persist to SharedPreferences
  void updateContact(int index, Contact updatedContact) {
    if (index >= 0 && index < _contacts.length) {
      _contacts[index] = updatedContact;
      _saveContacts(); // Persist the updated list
      notifyListeners();
    }
  }

  // Remove a contact by index and persist to SharedPreferences
  void removeContact(int index) {
    if (index >= 0 && index < _contacts.length) {
      _contacts.removeAt(index);
      _saveContacts(); // Persist the updated list
      notifyListeners();
    }
  }

  // Clear all contacts and persist to SharedPreferences
  void clearContacts() {
    _contacts.clear();
    _saveContacts(); // Persist the cleared list
    notifyListeners();
  }

  // Retrieve a specific contact by index
  Contact getContact(int index) {
    return _contacts[index];
  }

  // Delete repeated contacts by phone number
  void deleteRepeat(String phoneNumber) {
    for (int i = 0; i < _contacts.length; i++) {
      if (_contacts[i].phoneNumber == phoneNumber) {
        removeContact(i);
      }
    }
  }

  // Check if contact list is empty
  bool isEmpty() {
    return _contacts.isEmpty;
  }

  // Retrieve contact count
  int get contactCount => _contacts.length;

  // Pick an image using the ImagePicker package
  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
      notifyListeners();
    }
  }

  void resetImage() {
    _image = null;
    notifyListeners();
  }

  // Save contacts to SharedPreferences
  // After saving contacts
  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactsAsString = _contacts.map((contact) {
      return jsonEncode(contact.toJson());
    }).toList();
    await prefs.setStringList('contacts', contactsAsString);
    print('Contacts saved: $contactsAsString'); // Debug print statement
    notifyListeners();
  }

// After loading contacts
  Future<void> loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? contactsAsString = prefs.getStringList('contacts');
    if (contactsAsString != null) {
      _contacts = contactsAsString.map((contactString) {
        return Contact.fromJson(jsonDecode(contactString));
      }).toList();
      print('Contacts loaded: $_contacts'); // This will now print readable info
    } else {
      print('No contacts found in SharedPreferences.');
    }
    notifyListeners();
  }
}
