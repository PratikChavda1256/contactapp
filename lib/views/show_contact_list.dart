/*
title :- show contact list
description :-  shoe all contact
*/


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';


import '../controllers/contect_controller.dart';
import '../models/categoryModel.dart';
import '../models/contact_model.dart';
import 'edit_contect_list.dart';
import 'MyDrawer.dart';

class ShowContactList extends StatefulWidget {
  @override
  ShowContactListState createState() => ShowContactListState();
}

class ShowContactListState extends State<ShowContactList> {
  final ContactController contactController = Get.find();
  TextEditingController searchController = TextEditingController();
  bool isAscending = true;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Color(0xff00bf8e),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ContactSearchDelegate());
            },
          ),
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              setState(() {
                isAscending = !isAscending;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showCategoryFilterDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        try {
          List<Contact> contacts = contactController.contacts.toList();

          // Apply search filter
          if (searchController.text.isNotEmpty) {
            contacts = contacts.where((contact) =>
            contact.firstName
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
                contact.lastName
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())).toList();
          }

          // Apply category filter
          if (selectedCategory != null) {
            contacts = contacts
                .where((contact) => contact.category == selectedCategory)
                .toList();
          }

          // Apply sorting
          contacts.sort((a, b) {
            if (isAscending) {
              return a.firstName.compareTo(b.firstName);
            } else {
              return b.firstName.compareTo(a.firstName);
            }
          });

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              Contact contact = contacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: contact.imagePath != null
                      ? FileImage(File(contact.imagePath!))
                      : AssetImage('assets/default_avatar.jpg') as ImageProvider,
                ),
                title: Text('${contact.firstName} ${contact.lastName}'),
                subtitle: Text(contact.mobileNumber),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editContact(context, contact, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteContact(context, index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        } catch (e) {
          return Center(
            child: Text('Error loading contacts: $e'),
          );
        }
      }),
      drawer: MyDrawer(),
    );
  }

  //show category wise filter

  void showCategoryFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Category'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...buildCategoryFilterOptions(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  //filter by asinding and desceding order
  List<Widget> buildCategoryFilterOptions() {
    final List<Category> categories = Hive.box<Category>('category').values.toList();

    return categories.map((category) {
      return ListTile(
        title: Text(category.name),
        onTap: () {
          setState(() {
            selectedCategory = category.name;
          });
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  void editContact(BuildContext context, Contact contact, int index) {
    Get.to(EditContactScreen(contact: contact, index: index));
  }

  void _deleteContact(BuildContext context, int index) {
    try {
      contactController.deleteContact(index);
    } catch (e) {
      showErrorMessage('Error deleting contact: $e');
    }
  }

  void showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }
}

//serch the contect
class ContactSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Not used in this example
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final ContactController contactController = Get.find();
    List<Contact> contacts = contactController.contacts.toList();

    contacts = contacts.where((contact) =>
    contact.firstName
        .toLowerCase()
        .contains(query.toLowerCase()) ||
        contact.lastName
            .toLowerCase()
            .contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        Contact contact = contacts[index];
        return ListTile(
          title: Text('${contact.firstName} ${contact.lastName}'),
          subtitle: Text(contact.mobileNumber),
          onTap: () {
            close(context, '${contact.firstName} ${contact.lastName}');
          },
        );
      },
    );
  }
}
