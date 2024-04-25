import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/contact_model.dart';

class ContactController extends GetxController {
  final contacts = <Contact>[].obs;
  var path = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      final contactBox = await Hive.openBox<Contact>('contacts');
      contacts.assignAll(contactBox.values.toList());
    } catch (e) {
      print('Error loading contacts: $e');
      // Handle error loading contacts
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      final contactBox = await Hive.openBox<Contact>('contacts');
      await contactBox.add(contact);
      await loadContacts();
    } catch (e) {
      print('Error adding contact: $e');
      // Handle error adding contact
    }
  }

  Future<void> updateContact(int index, Contact updatedContact) async {
    try {
      final contactBox = await Hive.openBox<Contact>('contacts');
      await contactBox.putAt(index, updatedContact);
      await loadContacts();
    } catch (e) {
      print('Error updating contact: $e');
      // Handle error updating contact
    }
  }

  Future<void> deleteContact(int index) async {
    try {
      final contactBox = await Hive.openBox<Contact>('contacts');
      await contactBox.deleteAt(index);
      await loadContacts();
    } catch (e) {
      print('Error deleting contact: $e');
      // Handle error deleting contact
    }
  }
}
