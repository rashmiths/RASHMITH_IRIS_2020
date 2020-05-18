# RASHMITH_IRIS_2020
Todo app


How to Use Step 1:

Download or clone this repo by using the link below:
https://github.com/rashmiths/RASHMITH_IRIS_2020.git and open the folder The completeTodoAppUsingProvider

 Step 2:

Go to project root and execute the following command in console to get the required dependencies:

flutter pub get Step 3:

This project uses a custom icon inorder to overide the default icon run flutter packages pub run flutter_launcher_icons:main

Todo Features:

Home

Theme

newIcon

different fontStyle

TableCalender

Time And DatePicker

Hive Database

Provider

Validation of input

todo list added is sorted
deleting the todo:for which you should Long Press the List Tile
Editing Todo:Press the Edit Icon

Searching for a particular date:even though there is a chance of searching for a date only the list gets updated the table calender remains same making it easy to return to today's List

User Notifications added but not working 

Here is the core folder structure which flutter provides.

flutter-app/ |- android |- assets |- build |- ios |- lib |

assets:it has the icon of app along with the fonts used. Here is the folder structure we have been using in this project(Bloc Project)

lib/ | -notification/ |- model/ |- widgets/ |- main.dart

Now, lets dive into the lib folder which has the main code for the application.

Notifications— Contains all the files required for Notification

model/Todo.dart: defines A TodoItem,containes All the Provider functionalities of Adding deleting editing or completing a todo.

model/Todo.g.dart:Generated file which helps in inter conversion to binaary which in turn helps in hive Storage.

widgets — Contains the common widgets for your applications. For example, TodoList,screen etc.

main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, title, orientation etc.

Widgets Contains the common widgets.

widgets/ |- todolist.dart |- todoscreen.dart|-newTodo.dart


todolist.dart: This is the widget reponsible for the list of todo's ,it sorts,also checks ehether the list is empty,edits,deletes the todo. 

todoscreen.dart: this is the main page of the App which also has the functionality of navigating to a particular. even though there is a chance of searching for a date only the list updated the table calender remains same making it easy to return to today's List

newTodo.dart:This widet is responsible for the ModalBottomSheet throuh which u fill the information for todo which also provides Time Picker for Choosing Time.
