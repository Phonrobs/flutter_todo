import 'package:flutter/material.dart';

import 'package:map_view/map_view.dart';
import './pages/todoitems.dart';
import './models/todoItem.dart';

void main() {
  MapView.setApiKey('AIzaSyBuuuLEBC16MjNQSclJLBZxBlrDc0_jkno');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<TodoItem> _todoItems = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoItemsPage(_todoItems),
    );
  }
}
