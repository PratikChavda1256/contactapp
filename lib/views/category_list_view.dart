import 'package:contexapp/models/categoryModel.dart';
import 'package:contexapp/models/contact_model.dart';
import 'package:contexapp/views/MyDrawer.dart';
import 'package:contexapp/views/add_contect_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/category_controller.dart';

class HomeScreen extends StatelessWidget {
  final CategoryController categoryController = Get.find();

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Management'),
        backgroundColor: Color(0xff00bf8e),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 350,
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'First Name',
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
              style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
              ),
              onPressed: () {
                showAddCategoryDialog();
              },
              child: Text('Add Category'),
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

  Widget buildCategoryList() {
    return Expanded(
      child: ListView.builder(
        itemCount: categoryController.categories.length,
        itemBuilder: (context, index) {
          final category = categoryController.categories[index];
          return ListTile(
              title: Text(category.name),
              // onTap: () {
              //   _showEditCategoryDialog(context, category);
              // },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditCategoryDialog(context, category);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      confirmDeleteCategory(context, category, index);
                    },
                  ),
                ],
              ));
        },
      ),
    );
  }



  void showAddCategoryDialog(/*BuildContext context*/) {

    if (nameController.text.isEmpty ){

      return;
    }

    String categoryName = nameController.text.trim();
    categoryController.addCategory(Category(categoryName));
    nameController.clear();

  }

  void showEditCategoryDialog(BuildContext context, Category category) {
    TextEditingController nameController =
        TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: TextField(controller: nameController),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  categoryController.updateCategory(
                      category, nameController.text);
                  Navigator.pop(context);
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void confirmDeleteCategory(
      BuildContext context, Category category, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${category.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                categoryController.deleteCategory(category, index);
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
