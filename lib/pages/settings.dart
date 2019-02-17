import 'package:flutter/material.dart';

import '../models/todoItem.dart';
import '../widgets/mainDrawer.dart';

class SettingsPage extends StatelessWidget {
  final List<TodoItem> todoItems;

  SettingsPage(this.todoItems);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'General',
              ),
              Tab(
                text: 'Security',
              ),
              Tab(
                text: 'About',
              ),
            ],
          ),
        ),
        drawer: MainDrawerWidget(todoItems),
        body: TabBarView(
          children: <Widget>[
            Text('General Settings'),
            Text('Security Settings'),
            Text('About Us'),
          ],
        ),
      ),
    );
  }
}
