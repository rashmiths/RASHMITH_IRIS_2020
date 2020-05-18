import 'package:expense/model/TODO.dart';
import 'package:expense/widget/EXPENSE/newTodo.dart';
import 'package:table_calendar/table_calendar.dart';


import 'package:flutter/material.dart';

import './todolist.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int i = 0;
  DateTime selectedDate;
  CalendarController _controller;
  @override
  void initState() {
   
    _controller = CalendarController();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    TodoItem model=TodoItem('', '', '', DateTime.now(), false, DateTime.now());
    void startAddingTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTodo(selectedDate,model.notificationManager);
        });
  }
    var appbar = AppBar(
      title: Text(
        "TODO",
        style: TextStyle(fontFamily: 'OpenSans'),
      ),
      backgroundColor: Colors.black87,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: (){
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
      
    );

    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              calendarStyle: CalendarStyle(
               
                selectedColor: Colors.black87,
                todayColor: Colors.grey,
               
              ),
              availableCalendarFormats: const {
                CalendarFormat.twoWeeks: 'twoWeek',
              },
              
              calendarController: _controller,
              //endDay: DateTime.now(),
              initialCalendarFormat:CalendarFormat.twoWeeks,
              

              onDaySelected: (todaysDate,hi){
                setState(() {
                  selectedDate=todaysDate;

                });
              },
            ),
            Container(
              // margin: EdgeInsets.all(10.0),
              width: double.infinity,

              //child: Chart(appbar),
            ),
            TodoList(
                appbar, selectedDate == null ? DateTime.now() : selectedDate),
            // usertask(),
           
          ],
          
        ),
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: Colors.black87,
          child: Icon(Icons.add,color: Colors.white,),
          onPressed: () {
            startAddingTransaction(context);
          },
        ),
      ),
    );
  }
}
