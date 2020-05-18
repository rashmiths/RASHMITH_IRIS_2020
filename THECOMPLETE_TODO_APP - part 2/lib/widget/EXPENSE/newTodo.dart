import 'package:expense/Notification/notification.dart';
import 'package:expense/model/TODO.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewTodo extends StatefulWidget {
  final DateTime selectedDate;
  final NotificationManager manager;

  NewTodo(this.selectedDate,this.manager);

  @override
  _NewTodoState createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final priceNode = FocusNode();
  final _form = GlobalKey<FormState>();
  TimeOfDay _time = TimeOfDay.now();
  DateTime selectedTime=DateTime.now();

  var newProduct = TodoItem(
    DateTime.now().toString(),
    '',
    '',
    null,
    false,
    null,
  );
  @override
  void dispose() {
    priceNode.dispose();
    super.dispose();
  }

  void _saveForm(BuildContext context) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    Provider.of<TodoProvider>(context, listen: false).usertask(
      DateTime.now().toString(),
      newProduct.title,
      newProduct.detail,
      widget.selectedDate,
      newProduct.isCompleted,
      selectedTime,
    );
    int i=0;
    i=i++;
    widget.manager.showNotificationDaily(i, newProduct.title, newProduct.detail, selectedTime.hour, selectedTime.minute);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _selectTime() async {
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _time,
      );

      if (picked != null && picked != _time) {
        _time = picked;
        setState(() {
          
          final now = new DateTime.now();
          selectedTime=DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

         
        });
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Card(
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.only(
                // top: 10.0,
                left: 10.0,
                right: 10.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(priceNode);
                  },
                  onSaved: (value) {
                    newProduct = TodoItem(
                        newProduct.id,
                        value,
                        newProduct.detail,
                        newProduct.date,
                        newProduct.isCompleted,
                        newProduct.time);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please Enter the Title';
                    }
                    if (value.startsWith(RegExp(r'[0-9]'))) {
                      return 'Title cannot start with numbers';
                    }

                    return null;
                  },
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Detail'),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    focusNode: priceNode,
                    onSaved: (value) {
                      newProduct = TodoItem(
                        newProduct.id,
                        newProduct.title,
                        value,
                        newProduct.date,
                        newProduct.isCompleted,
                        newProduct.time,
                      );
                    },
                    
                    onFieldSubmitted: (_) {
                      _saveForm(context);
                    }),
                FlatButton(
                  onPressed: () {
                    _selectTime();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (selectedTime != null)
                        Text(DateFormat.jm().format(selectedTime).toString()),
                      Text(
                        'Choose Time',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.black87,
                  onPressed: () {
                    _saveForm(context);
                  },
                  child: Text(
                    'Add Task',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
