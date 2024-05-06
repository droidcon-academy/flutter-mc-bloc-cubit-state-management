import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content){
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(content),duration: const Duration(seconds: 2),));
}