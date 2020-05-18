import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense/model/TODO.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  final appbar;

  final DateTime selectedDate;

  TodoList(this.appbar, this.selectedDate);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final priceNode = FocusNode();

  @override
  void dispose() {
    priceNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TodoProvider>(context);
    final transactionbox = Hive.box('todo');
    final taskListfrombox = transactionbox.values.toList().cast<TodoItem>();

    final taskList = taskListfrombox.where((task) {
      return task.date.day == widget.selectedDate.day &&
          task.date.month == widget.selectedDate.month &&
          task.date.year == widget.selectedDate.year;
    }).toList();

    return Container(
      height: (MediaQuery.of(context).size.height -
              widget.appbar.preferredSize.height -
              MediaQuery.of(context).padding.top -
              100) *
          0.7,
      child: taskList.isEmpty
          ? Column(
              children: <Widget>[
                Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          DateFormat.yMMMd().format(widget.selectedDate),
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                Text(
                  'No Todo s Added!',
                  style: TextStyle(fontFamily: 'Quicksand'),
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/image/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctxt, index) {
                return Column(
                  children: <Widget>[
                    if (index == 0)
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          DateFormat.yMMMd().format(taskList[index].date),
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5.0,
                        margin: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 8,
                        ),
                        child: ListTile(
                          onLongPress: () {
                            //  transactionlist[index].id=DateTime.now().toString();
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text('Are yo sure u want to delete'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Provider.of<TodoProvider>(context,
                                                listen: false)
                                            .deletetxt(taskList[index].id);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No'),
                                    ),
                                  ],
                                ));
                          },
                          enabled: true,
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                  icon: taskList[index].isCompleted
                                      ? Icon(
                                          Icons.check_box,
                                        )
                                      : Icon(
                                          Icons.check_box_outline_blank,
                                        ),
                                  onPressed: () {
                                    Provider.of<TodoProvider>(context,
                                            listen: false)
                                        .changingCompleteness(
                                            taskList[index].id);
                                  }),
                              CircleAvatar(
                                backgroundColor: Colors.black87,
                                radius: 50.0,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: FittedBox(
                                      child: Text(
                                    //transactionlist[index]
                                   DateFormat.jm().format(taskList[index].time),
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            taskList[index].title,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand'),
                          ),
                          subtitle: Text(
                             taskList[index].detail),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                              ),
                              onPressed: () {
                                // editingscreen(context, widget.selectedDate,
                                //     taskList[index].id);
                                editscreen(
                                    priceNode,
                                    context,
                                    taskList[index].id,
                                    taskList[index].title,
                                    taskList[index].detail,
                                    widget.selectedDate,
                                    taskList[index].time);
                              }),
                        )),
                  ],
                );
              },
              itemCount: taskList.length),
    );
  }
}

Future editscreen(
    FocusNode priceNode, BuildContext context, id, title, detail, date, time) {
  final _form = GlobalKey<FormState>();
  var editedProduct = TodoItem(
    id,
    '',
    '',
    date,
    false,
    time,
  );
   
    Future<Null> _selectTime() async {
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null && picked != time) {
         
       
          
          final now = new DateTime.now();
          time=DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      }
    }
  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<TodoProvider>(context, listen: false).usertask(
      id,
      editedProduct.title,
      editedProduct.detail,
      editedProduct.date,
      editedProduct.isCompleted,
      time,
    );
    Navigator.of(context).pop();
  }

  return showDialog(
      context: context,
      child: Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 2.0, color: Colors.black)),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 240,
          child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  initialValue: title,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(priceNode);
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
                  onSaved: (value) {
                    editedProduct = TodoItem(
                        id,
                        value,
                        editedProduct.detail,
                        editedProduct.date,
                        editedProduct.isCompleted,
                        editedProduct.time);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Detail'),
                  initialValue: detail,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  focusNode: priceNode,
                  onSaved: (value) {
                    editedProduct = TodoItem(
                      editedProduct.id,
                      editedProduct.title,
                      value,
                      editedProduct.date,
                      editedProduct.isCompleted,
                      editedProduct.time,
                    );
                  },
                  
                ),
                
                FlatButton(
                  onPressed: () {
                    _selectTime();

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Change Time',style: TextStyle(fontWeight: FontWeight.bold),),
                      Text((DateFormat.jm().format(time))),
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {
                    _saveForm();
                  },
                  child: Text(
                    'Edit Task',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ));
}
