import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/locationData.dart';
import '../models/todoItem.dart';
import '../widgets/mainDrawer.dart';
import './todoItem.dart';

class TodoItemsPage extends StatefulWidget {
  final List<TodoItem> todoItems;

  TodoItemsPage(this.todoItems);

  @override
  State<StatefulWidget> createState() {
    return TodoItemsPageState();
  }
}

class TodoItemsPageState extends State<TodoItemsPage> {
  int _selectedItemIndex;
  bool _loading = false;

  void _loadTodoItems() {
    _loading = true;

    http
        .get('https://fluttermytodo.firebaseio.com/todoitems.json')
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData != null) {
        setState(() {
          responseData.forEach((String id, dynamic todoItem) {
            LocationData locationData;

            if (todoItem['locationData'] != null) {
              locationData = LocationData(
                  todoItem['locationData']['address'],
                  todoItem['locationData']['lat'],
                  todoItem['locationData']['lng']);
            }

            final TodoItem item = TodoItem(
              id,
              todoItem['title'],
              todoItem['note'],
              DateTime.parse(todoItem['start']),
              DateTime.parse(todoItem['end']),
              todoItem['completed'],
              locationData,
            );
            widget.todoItems.add(item);
          });

          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  void initState() {
    _loadTodoItems();
    super.initState();
  }

  void _addOrUpdateTodoItem(String title, String note, DateTime start,
      DateTime end, bool completed, LocationData locationData) {
    String serverId = '';

    if (_selectedItemIndex > -1) {
      serverId = widget.todoItems[_selectedItemIndex].id;
    }

    final Map<String, dynamic> mapTodoItem = {
      'title': title,
      'note': note,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'completed': completed,
    };

    if (locationData != null) {
      mapTodoItem['locationData'] = {
        'address': locationData.address,
        'lat': locationData.lat,
        'lng': locationData.lng
      };
    }

    if (_selectedItemIndex == -1) {
      http
          .post(
        'https://fluttermytodo.firebaseio.com/todoitems.json',
        body: json.encode(mapTodoItem),
      )
          .then((http.Response response) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        serverId = responseData['name'];
        final TodoItem newTodoItem = TodoItem(
            serverId, title, note, start, end, completed, locationData);

        setState(() {
          widget.todoItems.add(newTodoItem);
        });
      });
    } else {
      http
          .put(
        'https://fluttermytodo.firebaseio.com/todoitems/$serverId.json',
        body: json.encode(mapTodoItem),
      )
          .then((http.Response response) {
        final TodoItem newTodoItem = TodoItem(
            serverId, title, note, start, end, completed, locationData);

        setState(() {
          widget.todoItems[_selectedItemIndex] = newTodoItem;
        });

        _selectedItemIndex = -1;
      });
    }
  }

  void _deleteTodoItem() {
    if (_selectedItemIndex > -1) {
      String serverId = widget.todoItems[_selectedItemIndex].id;

      http
          .delete(
              'https://fluttermytodo.firebaseio.com/todoitems/$serverId.json')
          .then((http.Response response) {
        setState(() {
          widget.todoItems.removeAt(_selectedItemIndex);
          _selectedItemIndex = -1;
        });
      });
    }
  }

  Widget _buildTodoItemIcon(bool completed) {
    if (completed) {
      return Icon(Icons.check_circle);
    } else {
      return Icon(Icons.check_circle_outline);
    }
  }

  Widget _buildTodoItem(BuildContext context, int index) {
    final TodoItem item = widget.todoItems[index];

    return ListTile(
      title: Text(item.title),
      leading: _buildTodoItemIcon(item.completed),
      onTap: () {
        _selectedItemIndex = index;

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TodoItemPage(item, _addOrUpdateTodoItem, _deleteTodoItem)),
        );
      },
    );
  }

  Widget _buildTodoItems() {
    if (_loading) {
      return CircularProgressIndicator();
    } else if (widget.todoItems.length > 0) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _buildTodoItem(context, index),
        itemCount: widget.todoItems.length,
      );
    } else {
      return Text('No todo item.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todo Items'),
      ),
      drawer: MainDrawerWidget(widget.todoItems),
      body: Center(
        child: _buildTodoItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectedItemIndex = -1;

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TodoItemPage(null, _addOrUpdateTodoItem, null)),
          );
        },
        tooltip: 'New Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
