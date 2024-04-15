import 'package:contexapp/views/add_contect_list.dart';
import 'package:contexapp/views/category_list_view.dart';
import 'package:contexapp/views/show_contact_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff141414),
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              'Add Category',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => HomeScreen());

            },
          ),
          const Divider(
            color: Color(0xff0b4e3d),
            thickness: 1,
          ),
          ListTile(
            title: const Text(
              'Add Contact',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => AddContectList());
            },
          ),
          const Divider(
            color: Color(0xff0b4e3d),
            thickness: 1,
          ),
          ListTile(
            title: const Text(
              'Show Contact',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => ShowContactList());
            },
          ),
          const Divider(
            color: Color(0xff0b4e3d),
            thickness: 1,
          ),
          ListTile(
            title: const Text(
              ' ',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => ());
            },
          ),
          const Divider(
            color: Color(0xff0b4e3d),
            thickness: 1,
          ),
          ListTile(
            title: const Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => ());
            },
          ),
          const Divider(
            color: Color(0xff0b4e3d),
            thickness: 1,
          ),
          ListTile(
            title: const Text(
              ' ',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => ());
            },
          ),
          const Divider(
            color: Color(0xff0b4e3d),
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
