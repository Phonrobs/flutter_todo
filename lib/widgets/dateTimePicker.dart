import 'package:flutter/material.dart';

class DateTimePickerWidget extends StatefulWidget {
  final String label;
  final DateTime initDateTime;
  final Function(DateTime) onCompleted;

  DateTimePickerWidget(this.label, this.initDateTime, this.onCompleted);

  @override
  State<StatefulWidget> createState() {
    return DateTimePickerWidgetState();
  }
}

class DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.initDateTime;    
  }

  Future<DateTime> _showDateTimePicker(
      BuildContext context, DateTime initDate) async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2020),
    );

    if (date != null) {
      final TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: initDate.hour, minute: initDate.minute),
      );

      if (time != null) {
        return DateTime(
            date.year, date.month, date.day, time.hour, time.minute);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Text(
            '${widget.label}: ${_dateTime.toString()}',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _showDateTimePicker(context, _dateTime).then((DateTime value) {
                if (value != null) {
                  setState(() {
                    _dateTime = value;
                  });

                  widget.onCompleted(value);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
