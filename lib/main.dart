// lib/main.dart
import 'package:contexapp/controllers/category_controller.dart';
import 'package:contexapp/views/category_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'controllers/contect_controller.dart';
import 'models/categoryModel.dart';
import 'models/contact_model.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ContactAdapter());
  await Hive.openBox<Category>('category');
  await Hive.openBox<Contact>('contacts');
  Get.put(CategoryController());
  Get.put(ContactController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
