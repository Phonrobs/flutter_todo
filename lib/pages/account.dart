import 'package:flutter/material.dart';

import '../widgets/mainDrawer.dart';
import '../models/todoItem.dart';

class AccountPage extends StatelessWidget {
  final List<TodoItem> todoItems;

  AccountPage(this.todoItems);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account'),
        ),
        drawer: MainDrawerWidget(todoItems),
        body: Text('Account Settings'),
      );
  }
}