/*
title :- add contect
description :-  add contect in this appication.
*/


import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/category_controller.dart';
import '../controllers/contect_controller.dart';
import '../models/contact_model.dart';
import '../views/show_contact_list.dart';
import 'MyDrawer.dart';

class AddContectList extends StatefulWidget {
  const AddContectList({super.key});

  @override
  State<AddContectList> createState() => AddContectListState();
}

class AddContectListState extends State<AddContectList> {
  final CategoryController categoryController = Get.find();
  final ContactController contactController = Get.find();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedCategory;
  String? _imagePath;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> selectImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error selecting image: $e');
      // Handle image selection error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        backgroundColor: const Color(0xff00bf8e),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: selectImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: _imagePath != null
                        ? ClipOval(
                      child: !kIsWeb
                          ? Image.file(
                        File(_imagePath!),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        _imagePath!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: mobileNumberController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                buildCategoryDropdown(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveContact,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  //------------------------------------------this show all category

  Widget buildCategoryDropdown() {
    return Obx(() {
      List<String> uniqueCategoryNames = categoryController.categories
          .map((category) => category.name)
          .toSet()
          .toList();

      return DropdownButtonFormField(
        decoration: const InputDecoration(labelText: 'Category'),
        value: selectedCategory,
        items: uniqueCategoryNames.map((categoryName) {
          return DropdownMenuItem(
            value: categoryName,
            child: Text(categoryName),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value as String?;
          });
        },
      );
    });
  }

  //--------------------------save contect  in hive data base

  void saveContact() {
    if (_imagePath == null ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        selectedCategory == null) {
      print('Incomplete contact information');
      return;
    }

    try {
      Contact newContact = Contact(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobileNumber: mobileNumberController.text,
        email: emailController.text,
        category: selectedCategory!,
        imagePath: _imagePath,
      );

      contactController.addContact(newContact);

      firstNameController.clear();
      lastNameController.clear();
      mobileNumberController.clear();
      emailController.clear();

      Get.to(() => ShowContactList());
    } catch (e) {
      print('Error saving contact: $e');
      // Handle error saving contact
    }
  }
}
