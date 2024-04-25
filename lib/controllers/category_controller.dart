import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/categoryModel.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var selectedCategory = Category('').obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final categoryBox = await Hive.openBox<Category>('category');
      categories.assignAll(categoryBox.values.toList());
    } catch (e) {
      print('Error loading categories: $e');
      // Handle error loading categories
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      final categoryBox = await Hive.openBox<Category>('category');
      await categoryBox.add(category);
      await loadCategories();
    } catch (e) {
      print('Error adding category: $e');
      // Handle error adding category
    }
  }

  Future<void> updateCategory(Category category, String newName) async {
    try {
      category.name = newName;
      await category.save();
      await loadCategories();
    } catch (e) {
      print('Error updating category: $e');
      // Handle error updating category
    }
  }

  Future<void> deleteCategory(Category category, int index) async {
    try {
      final categoryBox = await Hive.openBox<Category>('category');
      await categoryBox.deleteAt(index);
      await loadCategories();
    } catch (e) {
      // Handle error deleting category
      print('Error deleting category: $e');

    }
  }

  void selectCategory(Category category) {
    selectedCategory.value = category;
  }
}
