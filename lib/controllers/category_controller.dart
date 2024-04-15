import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:get/get_state_manager/get_state_manager.dart';


import '../models/categoryModel.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var selectedCategory = Category('').obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    final categoryBox = Hive.box<Category>('category');
    categories.assignAll(categoryBox.values.toList());
  }

  void addCategory(Category category) {
    final categoryBox = Hive.box<Category>('category');
    categoryBox.add(category);
    loadCategories();
  }

  void updateCategory(Category category, String newName) {
    category.name = newName;
    category.save();
    loadCategories();
  }

  void deleteCategory(Category category , int index) {
    final categoryBox = Hive.box<Category>('category');
    // final List<Category> currentCategories = categoryBox.values.toList();
    //

    // final indexToDelete = currentCategories.indexWhere((cat) => cat.name == category.name);
    //
    // if (indexToDelete != -1) {
    // categoryBox.deleteAt(indexToDelete);
    categoryBox.deleteAt(index);
      // Reload categories after deletion
      loadCategories();
    // }
  }


  void selectCategory(Category category) {
    selectedCategory.value = category;
  }
}
