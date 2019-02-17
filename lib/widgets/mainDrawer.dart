import 'package:flutter/material.dart';

import '../models/todoItem.dart';
import '../pages/settings.dart';
import '../pages/todoItems.dart';
import '../pages/account.dart';

class MainDrawerWidget extends StatelessWidget {
  final List<TodoItem> todoItems;

  MainDrawerWidget(this.todoItems);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Main Menu',
              style: TextStyle(fontSize: 20.0),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Todo List'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TodoItemsPage(todoItems)));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SettingsPage(todoItems)));
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AccountPage(todoItems)));
            },
          ),
        ],
      ),
    );
  }
}
