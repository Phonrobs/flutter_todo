import 'package:flutter/material.dart';

import '../models/locationData.dart';
import '../models/todoItem.dart';
import '../widgets/dateTimePicker.dart';
import '../widgets/locationPicker.dart';
import '../widgets/imagePicker.dart';

class TodoItemPage extends StatefulWidget {
  final TodoItem todoItem;
  final Function(String title, String note, DateTime start, DateTime end,
      bool completed, LocationData locationData) addOrUpdateTodoItem;
  final Function deleteTodoItem;

  TodoItemPage(this.todoItem, this.addOrUpdateTodoItem, this.deleteTodoItem);

  @override
  State<StatefulWidget> createState() {
    return _TodoItemPageState();
  }
}

class _TodoItemPageState extends State<TodoItemPage> {
  String _title = '';
  String _note = '';
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  LocationData _locationData = null;
  bool _completed = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.todoItem != null) {
      _title = widget.todoItem.title;
      _note = widget.todoItem.note;
      _start = widget.todoItem.start;
      _end = widget.todoItem.end;
      _completed = widget.todoItem.completed;
      _locationData = widget.todoItem.locationData;
    }
  }

  void _setLocationData(LocationData locationData) {
    _locationData = locationData;
  }

  Widget _appBarTitle() {
    if (widget.todoItem == null) {
      return Text('Add New Item');
    } else {
      return Text('Edit Item');
    }
  }

  List<Widget> _appBarActions() {
    final List<Widget> actions = [
      IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.addOrUpdateTodoItem(
                _title, _note, _start, _end, _completed, _locationData);
            Navigator.pop(context);
          }
        },
      )
    ];

    if (widget.todoItem != null) {
      actions.add(IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () {
          widget.deleteTodoItem();
          Navigator.pop(context);
        },
      ));
    }

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(),
        actions: _appBarActions(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: TextFormField(
                initialValue: _title,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter title';
                  }
                },
                onSaved: (String value) {
                  _title = value;
                },
              ),
            ),
            ListTile(
              title: TextFormField(
                initialValue: _note,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Note'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (String value) {
                  _note = value;
                },
              ),
            ),
            ListTile(
              title: DateTimePickerWidget(
                  'Start', _start, (DateTime value) => _start = value),
            ),
            ListTile(
              title: DateTimePickerWidget(
                  'End', _end, (DateTime value) => _end = value),
            ),
            ListTile(
              title: LocationPickerWidget(_locationData, _setLocationData),
            ),
            SwitchListTile(
              title: Text('Completed'),
              value: _completed,
              onChanged: (bool value) {
                setState(() {
                  _completed = value;
                });
              },
            ),
            ListTile(
              title: ImagePickerWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
