import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/models/category_model.dart';

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 2; // Unique ID for this type

  @override
  CategoryModel read(BinaryReader reader) {
    final name = reader.read();
    final iconCodePoint = reader.readInt();
    final colorValue = reader.readInt();
    return CategoryModel(
      name: name as String,
      icon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
      color: Color(colorValue),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer.write(obj.name);
    writer.writeInt(obj.icon.codePoint);
    writer.writeInt(obj.color.value);
  }
}
