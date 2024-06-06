import 'package:blocify/data/models/category_model.dart';
import 'package:flutter/material.dart';

List<CategoryModel> expenseCategoryList = [
  CategoryModel(name: 'Shopping', icon: Icons.shopping_cart, color: Colors.purple),
  CategoryModel(name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
  CategoryModel(name: 'Entertainment', icon: Icons.local_movies, color: Colors.teal),
  CategoryModel(name: 'Food', icon: Icons.fastfood, color: Colors.pinkAccent),
  CategoryModel(name: 'Rent', icon: Icons.home, color: Colors.brown),
  CategoryModel(name: 'Groceries', icon: Icons.local_grocery_store,color: Colors.lightGreen),
  CategoryModel(name: 'Health', icon: Icons.favorite, color: Colors.red),
  CategoryModel(name: 'Utilities', icon: Icons.settings, color: Colors.deepOrangeAccent),
  CategoryModel(name: 'Travel', icon: Icons.airplanemode_active, color: Colors.indigo),
  CategoryModel(name: 'Education', icon: Icons.school, color: Colors.black),
  CategoryModel(name: 'Insurance', icon: Icons.security, color: Colors.deepPurple),
  CategoryModel(name: 'Gifts', icon: Icons.card_giftcard, color: Colors.amber),
  CategoryModel(name: 'Miscellaneous', icon: Icons.question_mark, color: Colors.blueGrey),
];

List<CategoryModel> incomeCategoryList = [
  CategoryModel(name: 'Salary', icon: Icons.attach_money, color: Colors.green),
  CategoryModel(name: 'Business', icon: Icons.business, color: Colors.brown),
  CategoryModel(name: 'Freelance', icon: Icons.work, color: Colors.blue),
  CategoryModel(name: 'Investments', icon: Icons.trending_up, color: Colors.orange),
  CategoryModel(name: 'Rental Income', icon: Icons.add_home, color: Colors.cyan),
  CategoryModel(name: 'Commission', icon: Icons.cut_rounded, color: Colors.black),
  CategoryModel(name: 'Royalty', icon: Icons.diamond, color: Colors.pinkAccent),
  CategoryModel(name: 'Gifts', icon: Icons.handshake, color: Colors.purple),
  CategoryModel(name: 'Bonus', icon: Icons.star, color: Colors.amber),
  CategoryModel(name: 'Other', icon: Icons.category_rounded, color: Colors.grey),
];
