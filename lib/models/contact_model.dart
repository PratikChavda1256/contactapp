// import 'package:hive/hive.dart';
//
// part 'contact_model.g.dart';
//
// @HiveType(typeId: 1) // Unique typeId for the Contact model
// class Contact extends HiveObject {
//   @HiveField(0)
//   late String firstName;
//
//   @HiveField(1)
//   late String lastName;
//
//   @HiveField(2)
//   late String mobileNumber;
//
//   @HiveField(3)
//   late String email;
//
//   @HiveField(4)
//   late String category;
//
//   Contact({
//     required this.firstName,
//     required this.lastName,
//     required this.mobileNumber,
//     required this.email,
//     required this.category,
//   });
// }
//
//

import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 1)
class Contact extends HiveObject {
  @HiveField(0)
  late String firstName;

  @HiveField(1)
  late String lastName;

  @HiveField(2)
  late String mobileNumber;

  @HiveField(3)
  late String email;

  @HiveField(4)
  late String category;

  @HiveField(5)
  String? imagePath; // Image path field

  Contact({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    required this.category,
    this.imagePath,
  });
}
