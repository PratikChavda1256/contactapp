/*
title :- category
description :-  basic crud operation in this category
*/





import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contexapp/models/categoryModel.dart';
import 'package:contexapp/views/MyDrawer.dart';
import '../controllers/category_controller.dart';

class HomeScreen extends StatelessWidget {
  final CategoryController categoryController = Get.find();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        backgroundColor: const Color(0xff00bf8e),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 350,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Category Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color(0xff00bf8e),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: showAddCategoryDialog,
              child: const Text('Add Category'),
            ),
            Expanded(
              child: Obx(() => buildCategoryList()),
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }

  //-------------------------------show all category in bottom
  Widget buildCategoryList() {
    return Expanded(
      child: ListView.builder(
        itemCount: categoryController.categories.length,
        itemBuilder: (context, index) {
          final category = categoryController.categories[index];
          return ListTile(
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showEditCategoryDialog(context, category);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    confirmDeleteCategory(context, category, index);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //--------------------show dialoag box to delete the
  void showAddCategoryDialog() {
    try {
      if (nameController.text.trim().isEmpty) {
        throw Exception('Category name cannot be empty');
      }

      String categoryName = nameController.text.trim();
      categoryController.addCategory(Category(categoryName));
      nameController.clear();
    } catch (e) {
      showErrorMessage('Failed to add category: $e');
    }
  }


  void showEditCategoryDialog(BuildContext context, Category category) {
    TextEditingController editNameController =
    TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(controller: editNameController),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  if (editNameController.text.trim().isEmpty) {
                    throw Exception('Category name cannot be empty');
                  }

                  categoryController.updateCategory(
                      category, editNameController.text.trim());
                  Navigator.pop(context); // Close the dialog
                } catch (e) {
                  showErrorMessage('Failed to update category: $e');
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // ------------------------delete category
  void confirmDeleteCategory(
      BuildContext context, Category category, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${category.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  categoryController.deleteCategory(category, index);
                  Navigator.pop(context); // Close the dialog
                } catch (e) {
                  showErrorMessage('Failed to delete category: $e');
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
