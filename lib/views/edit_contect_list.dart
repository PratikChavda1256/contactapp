// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../controllers/category_controller.dart';
// import '../controllers/contect_controller.dart';
// import '../models/contact_model.dart';
// import 'MyDrawer.dart';
//
// class EditContactScreen extends StatelessWidget {
//   final Contact contact;
//   final int index;
//
//   EditContactScreen({required this.contact, required this.index});
//   final ContactController contactController = Get.find();
//   final CategoryController categoryController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController firstNameController =
//     TextEditingController(text: contact.firstName);
//     TextEditingController lastNameController =
//     TextEditingController(text: contact.lastName);
//     TextEditingController mobileNumberController =
//     TextEditingController(text: contact.mobileNumber);
//     TextEditingController emailController =
//     TextEditingController(text: contact.email);
//
//     // Retrieve all unique category names
//     List<String> uniqueCategoryNames = CategoryController.categories
//         .map((category) => category.name)
//         .toSet()
//         .toList();
//
//     // Determine the index of the contact's category
//     int selectedCategoryIndex =
//     uniqueCategoryNames.indexOf(contact.category);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Contact'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: firstNameController,
//               decoration: InputDecoration(labelText: 'First Name'),
//             ),
//             TextFormField(
//               controller: lastNameController,
//               decoration: InputDecoration(labelText: 'Last Name'),
//             ),
//             TextFormField(
//               controller: mobileNumberController,
//               decoration: InputDecoration(labelText: 'Mobile Number'),
//             ),
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Mobile Number'),
//             ),
//             SizedBox(height: 20),
//             DropdownButtonFormField(
//               decoration: InputDecoration(labelText: 'Category'),
//               value: uniqueCategoryNames[selectedCategoryIndex],
//               items: uniqueCategoryNames.map((categoryName) {
//                 return DropdownMenuItem(
//                   value: categoryName,
//                   child: Text(categoryName),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 // Handle category selection
//                 // No action needed in this case since editing an existing contact
//               },
//             ),
//             SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: () {
//                 // Update the contact with new values
//                 Contact updatedContact = Contact(
//                   firstName: firstNameController.text,
//                   lastName: lastNameController.text,
//                   mobileNumber: mobileNumberController.text,
//                   email: emailController.text,
//                   category: contact.category,
//                 );
//                 contactController.updateContact(index, updatedContact);
//                 // Navigate back to contact list screen
//                 Get.back();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//       // drawer: MyDrawer(),
//     );
//
//   }
// }
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/category_controller.dart';
import '../controllers/contect_controller.dart';
import '../models/contact_model.dart';
import 'MyDrawer.dart';

class EditContactScreen extends StatelessWidget {
  final Contact contact;
  final int index;

  EditContactScreen({super.key, required this.contact, required this.index});

  final ContactController contactController = Get.find();
  final CategoryController categoryController = Get.find();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController =
        TextEditingController(text: contact.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: contact.lastName);
    TextEditingController mobileNumberController =
        TextEditingController(text: contact.mobileNumber);
    TextEditingController emailController =
        TextEditingController(text: contact.email);
    String? _imagePath = contact.imagePath;
    contactController.path.value = _imagePath!;
    Future<void> selectImage() async {
      final picker = ImagePicker();


      print("right");
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // setState(() {
         contactController.path.value = pickedFile.path;
        _imagePath = contactController.path.value;
        // }
        // );
      }
    }


    List<String> uniqueCategoryNames = categoryController.categories
        .map((category) => category.name)
        .toSet()
        .toList();
    // List<String> uniqueCategoryNames = CategoryController.categories.value.map((category));

    int selectedCategoryIndex = uniqueCategoryNames.indexOf(contact.category);
    if (selectedCategoryIndex == -1) {
      selectedCategoryIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
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
                      ? Obx(
                          () => ClipOval(
                            child: Image.file(
                              File(contactController.path.value),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                ),
              ),
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: mobileNumberController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Category'),
                value: uniqueCategoryNames[selectedCategoryIndex],
                items: uniqueCategoryNames.map((categoryName) {
                  return DropdownMenuItem(
                    value: categoryName,
                    child: Text(categoryName),
                  );
                }).toList(),
                onChanged: (value) {

                  selectedCategory = value as String?;
                  selectedCategoryIndex =
                      uniqueCategoryNames.indexOf(selectedCategory!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {

                  Contact updatedContact = Contact(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    mobileNumber: mobileNumberController.text,
                    email: emailController.text,
                    category: uniqueCategoryNames[selectedCategoryIndex],
                    imagePath: _imagePath,
                  );
                  contactController.updateContact(index, updatedContact);
                  // Navigate back to contact list screen
                  Get.back();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
      // drawer: MyDrawer(),
    );
  }
}
