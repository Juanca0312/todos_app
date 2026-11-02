import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:todos_app/todos_app.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<Map>('tasks');
  runApp(const TodosApp());
}
