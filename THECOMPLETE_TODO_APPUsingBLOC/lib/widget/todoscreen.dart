import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import './todolist.dart';
import '../bloc/counter_bloc.dart';
import '../model/TODO.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int i = 0;
  DateTime selectedDate = DateTime.now();
  CalendarController _controller;
  @override
  void initState() {
    _controller = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      title: Text(
        "TODO",
        style: TextStyle(fontFamily: 'OpenSans'),
      ),
      backgroundColor: Colors.black87,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TODO",
          style: TextStyle(fontFamily: 'OpenSans'),
        ),
        backgroundColor: Colors.black87,
        //for searching a date directly on which only the list gets updated using the calender u can easily come todays date
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2016),
                  lastDate: DateTime.now(),
                ).then((pickedDate) {
                  if (pickedDate == null) {
                    return;
                  }

                  setState(() {
                    selectedDate = pickedDate;
                  });
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              calendarStyle: CalendarStyle(
                selectedColor: Colors.black87,
                todayColor: Colors.grey,
              ),

              calendarController: _controller,
              //endDay: DateTime.now(),
              initialCalendarFormat: CalendarFormat.twoWeeks,
              availableCalendarFormats: const {
                CalendarFormat.twoWeeks: 'twoWeek',
              },

              onDaySelected: (todaysDate, hi) {
                setState(() {
                  selectedDate = todaysDate;
                });
              },
            ),
            //todoList

            TodoList(
                appbar, selectedDate == null ? DateTime.now() : selectedDate),
           
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: Colors.black87,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            //NEW TASK
            showBottomSheet(
                context: context,
                builder: (_) {
                  final priceNode = FocusNode();
                  final _form = GlobalKey<FormState>();
                  TimeOfDay _time = TimeOfDay.now();
                  DateTime selectedTime = DateTime.now();

                  var newProduct = TodoItem(
                    DateTime.now().toString(),
                    '',
                    '',
                    null,
                    false,
                    null,
                  );
                 

                  Future<Null> _selectTime() async {
                    final TimeOfDay picked = await showTimePicker(
                      context: context,
                      initialTime: _time,
                    );

                    if (picked != null && picked != _time) {
                      _time = picked;
                      setState(() {
                       
                        final now = new DateTime.now();
                        selectedTime = DateTime(now.year, now.month, now.day,
                            picked.hour, picked.minute);
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
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  10),
                          child: Column(
                            children: <Widget>[
                              // title field with validators
                              TextFormField(
                                decoration: InputDecoration(labelText: 'Title'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(priceNode);
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
                              //detail field 
                              TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Detail'),
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
                                    final isValid =
                                        _form.currentState.validate();
                                    if (!isValid) {
                                      return;
                                    }

                                    _form.currentState.save();

                                    final recentTodo = TodoItem(
                                      DateTime.now().toString(),
                                      newProduct.title,
                                      newProduct.detail,
                                      selectedDate,
                                      newProduct.isCompleted,
                                      selectedTime,
                                    );

                                    BlocProvider.of<CounterBloc>(context)
                                        .add(IncrementEvent(recentTodo));

                                    Navigator.of(context).pop();
                                  }),
                              //For choosing a time which may help in notification
                              FlatButton(
                                onPressed: () {
                                  _selectTime();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                  
                                    Text(
                                      'Choose Time',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              RaisedButton(
                                color: Colors.black87,
                                onPressed: () {
                                  final isValid = _form.currentState.validate();
                                  if (!isValid) {
                                    return;
                                  }

                                  _form.currentState.save();

                                  final recentTodo = TodoItem(
                                    DateTime.now().toString(),
                                    newProduct.title,
                                    newProduct.detail,
                                    selectedDate,
                                    newProduct.isCompleted,
                                    selectedTime,
                                  );
                                  BlocProvider.of<CounterBloc>(context)
                                      .add(IncrementEvent(recentTodo));

                                  Navigator.of(context).pop();
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
                });
          },
        ),
      ),
    );
  }
}
