# Todo app with BLOC

# How to Use 

## Step 1: 
Download or clone this repo by using the link below: https://github.com/rashmiths/RASHMITH_IRIS_2020.git 

## Step 2: 
Go to project root and execute the following command in console to get the required dependencies:
flutter pub get 

## Step 3: 
Run the Project


# Todo Features:

Home 

Theme 

newIcon 

different fontStyle

TableCalender 

Time And DatePicker 

Hive Database Bloc

Validation 

todo list added is sorted 

searching for a particular date:even though there is a chance of searching for a date only the list gets updated the table calender remains same making it easy to return to today's List adding deleting editing completing a TODO 

# Here is the core folder structure which flutter provides. 

### flutter-app/ |- android |- assets |- build |- ios |- lib |- test 

assets:it has the icon of app along with the fonts used. 

Here is the folder structure we have been using in this project

(Bloc Project) lib/ | -Bloc/ |- model/ |- widgets/ |- main.dart
Now, lets dive into the lib folder which has the main code for the application.

Bloc — Contains all the files required for Bloc Functionalities widgets — Contains the common widgets for your applications. 
For example, TodoList,screen etc.

model/Todo:Class that Defines a TodoItem 

model/Todo.g:responsible for binary conversions required for storage in hive 

main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, title, orientation etc.

Widgets Contains the common widgets. 

widgets/ |- todolist.dart |- todoscreen.dart todolist.dart: This is the widget reponsible for the list of todo's ,it sorts,also checks ehether the list is empty,edits,deletes the todo.

todoscreen.dart: this is the main page of the App which also has the functionality of navigating to a particular day,adding new todo. eve though there is a chance of searching for a date only the list updated the table calender remains same making it easy to return to today's List


## Photos of app:  
<table>
<tr>
    <td><img src="https://user-images.githubusercontent.com/54366663/82353582-46285980-9a1d-11ea-9701-0fce9a53e90e.jpeg" width=250 height=480></td>
    <td><img src="https://user-images.githubusercontent.com/54366663/82353834-97d0e400-9a1d-11ea-8ebb-c2d69f0e5de8.jpeg" width=250 height=480></td>
    <td><img src="https://user-images.githubusercontent.com/54366663/82353852-9e5f5b80-9a1d-11ea-972a-eda6c5cc2132.jpeg" width=250 height=480></td>
    <td><img src="https://user-images.githubusercontent.com/54366663/82353893-acad7780-9a1d-11ea-8bd2-e7f1d7744598.jpeg" width=250 height=480></td>
  </tr>
</table>
        

## GIF

### How to delete a todo

![20200519_223148](https://user-images.githubusercontent.com/54366663/82356050-b2588c80-9a20-11ea-803f-7aaf35b0a364.gif)
