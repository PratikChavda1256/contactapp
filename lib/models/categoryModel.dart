// models/category_model.dart

import 'package:hive/hive.dart';

part 'categoryModel.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  late String name;

  Category(this.name);
}
