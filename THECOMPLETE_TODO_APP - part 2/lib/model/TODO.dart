
import 'package:expense/Notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'TODO.g.dart';

@HiveType(typeId: 0)
class TodoItem {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String detail;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  bool isCompleted;
  @HiveField(5)
  DateTime time;
  final NotificationManager notificationManager = NotificationManager();

  TodoItem(this.id, this.title, this.detail, this.date, this.isCompleted,this.time);
}

class TodoProvider with ChangeNotifier {

// TimeOfDay timeSelected;

// void togetTime(pickedTime)
// {
//   timeSelected=pickedTime;
//   notifyListeners();

// }

  void usertask(String id, String title, String detail, DateTime selectedDate,
      bool isCompleted,DateTime time) {
    final newtxt = TodoItem(id, title, detail,
        selectedDate == null ? DateTime.now() : selectedDate, isCompleted,time);

    final transactionBox = Hive.box('todo');

    transactionBox.put(id, newtxt);

    notifyListeners();
  }

  void deletetxt(String id) {
    final transactionbox = Hive.box('todo');
    transactionbox.delete(id);
    notifyListeners();
  }


  void changingCompleteness(String id) {
    final transactionbox = Hive.box('todo');
    final TodoItem referedTask = transactionbox.get(id);
    final editedTask = TodoItem(id, referedTask.title, referedTask.detail,
        referedTask.date, !(referedTask.isCompleted),referedTask.time);
    transactionbox.put(id, editedTask);
    notifyListeners();
  }
}
