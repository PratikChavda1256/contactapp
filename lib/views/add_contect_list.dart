import 'dart:io';

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
  const AddContectList({Key? key}) : super(key: key);

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

  Future<void> selectImage() async {
    final picker = ImagePicker();
    print("right");
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
        backgroundColor: Color(0xff00bf8e),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
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
                        ? ClipOval(

                            child: !kIsWeb ? Image(
                              image:  Image.file(
                                File(_imagePath!),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ).image,
                            ) :Image.network(_imagePath!, width: 120,
                              height: 120,
                              fit: BoxFit.cover,),
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                  ),
                ),

                SizedBox(height: 20),
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
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 20),
                buildCategoryDropdown(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveContact,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  Widget buildCategoryDropdown() {
    return Obx(() {
      List<String> uniqueCategoryNames = categoryController.categories
          .map((category) => category.name)
          .toSet()
          .toList();

      return DropdownButtonFormField(
        decoration: InputDecoration(labelText: 'Category'),
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

  void saveContact() {
    if (_imagePath==null || firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        selectedCategory == null) {
      print('this is imagepath ${_imagePath} ');

      return;
    }
    print('this is image path ${_imagePath}');
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
  }
}
