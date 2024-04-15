import 'package:get/get.dart';
import 'package:hive/hive.dart';
// import 'package:your_app_name/models/contact_model.dart';

import '../models/contact_model.dart';

class ContactController extends GetxController {
  final contacts = <Contact>[].obs;
  var path = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadContect();
  }

  void loadContect() {
    final categoryBox = Hive.box<Contact>('contacts');
    contacts.assignAll(categoryBox.values.toList());
  }

  void addContact(Contact contact) {
    final categoryBox = Hive.box<Contact>('contacts');
    categoryBox.add(contact);
    // contacts.add(contact);
    loadContect();

  }

  void updateContact(int index, Contact updatedContact) {
    final categoryBox = Hive.box<Contact>('contacts');
    categoryBox.putAt(index, updatedContact);
    loadContect();
  }

  void deleteContact(int index) {
    final categoryBox = Hive.box<Contact>('contacts');
    categoryBox.deleteAt(index);
    loadContect();
  }
}
