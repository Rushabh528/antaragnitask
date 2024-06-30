import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Contact {
  String id;
  String name;
  String phoneNumber;
  String email;
  File? image;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.image,
  });

  factory Contact.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Contact(
      id: doc.id,
      name: data['name'] ?? '',
      phoneNumber: data['phone'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] != null ? File(data['image']) : null,
    );
  }
}

class ContactsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  ContactsProvider() {
    fetchContacts();
  }

  void fetchContacts() {
    _firestore.collection('Contact').snapshots().listen((snapshot) {
      _contacts =
          snapshot.docs.map((doc) => Contact.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }

  void addContact(Contact contact) {
    _firestore.collection('Contact').add({
      'name': contact.name,
      'phone': contact.phoneNumber,
      'email': contact.email,
      'image': contact.image?.path,
    });
  }

  void updateContact(Contact oldContact, Contact newContact) {
    _firestore.collection('Contact').doc(oldContact.id).update({
      'name': newContact.name,
      'phone': newContact.phoneNumber,
      'email': newContact.email,
      'image': newContact.image?.path,
    });
  }

  void removeContact(String id) {
    _firestore.collection('Contact').doc(id).delete();
  }
}
