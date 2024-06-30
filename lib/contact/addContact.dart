// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:antaragnitask/contact/contactProvider.dart';

class AddContact extends StatefulWidget {
  final Contact? contact; // Accept contact to edit if provided

  const AddContact({Key? key, this.contact}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool show = false;

  late TextEditingController controller1;
  late TextEditingController controller2;
  late TextEditingController controller3;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController(text: widget.contact?.name ?? '');
    controller2 =
        TextEditingController(text: widget.contact?.phoneNumber ?? '');
    controller3 = TextEditingController(text: widget.contact?.email ?? '');
    _image = widget.contact?.image;
    show = _image != null;
  }

  Future<void> _pickImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        show = true;
      });
    }
  }

  Future<void> _pickImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        show = true;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
      show = false;
    });
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final updatedContact = Contact(
        name: controller1.text,
        phoneNumber: controller2.text,
        email: controller3.text,
        image: _image,
        id: widget.contact?.id ?? '',
      );

      if (widget.contact == null) {
        Provider.of<ContactsProvider>(context, listen: false)
            .addContact(updatedContact);
      } else {
        // Update existing contact
        Provider.of<ContactsProvider>(context, listen: false)
            .updateContact(widget.contact!, updatedContact);
      }

      Navigator.pop(context);
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? "Add Contact" : "Edit Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ENTER YOUR NAME:"),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  controller: controller1,
                ),
                SizedBox(height: 20),
                Text("ENTER YOUR MOBILE NUMBER:"),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  controller: controller2,
                  validator: _validatePhoneNumber,
                ),
                SizedBox(height: 20),
                Text("ENTER YOUR EMAIL:"),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  controller: controller3,
                  validator: _validateEmail,
                ),
                SizedBox(height: 20),
                Text("Upload Image for your profile:"),
                SizedBox(height: 10),
                Center(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(160, 50)),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: 115,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _pickImageCamera();
                                      Navigator.pop(context);
                                    },
                                    child: ListTile(
                                      leading: Icon(Icons.camera_alt_outlined),
                                      title: Text("Choose From Camera"),
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.grey),
                                  InkWell(
                                    onTap: () {
                                      _pickImageGallery();
                                      Navigator.pop(context);
                                    },
                                    child: ListTile(
                                      leading: Icon(Icons.photo),
                                      title: Text("Choose From Gallery"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.upload), Text("Select Files")],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                show && _image != null
                    ? Container(
                        height: 200,
                        child: Stack(
                          children: [
                            Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: _removeImage,
                                child: Container(
                                  color: Colors.black54,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _saveContact();
                    }
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff00203F).withOpacity(0.9),
                      ),
                      width: 260,
                      height: 55,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            widget.contact == null
                                ? "Add contact"
                                : "Update contact",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
