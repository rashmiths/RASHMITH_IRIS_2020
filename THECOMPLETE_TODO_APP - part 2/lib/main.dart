
import 'package:expense/widget/EXPENSE/todoscreen.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import './model/TODO.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(TodoItemAdapter());
   await Hive.openBox('todo');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  List<Box> boxlist = [];

  Future openingBox() async {
    var expensebox = await Hive.openBox('todo');

    boxlist.add(expensebox);

    return boxlist;
  }

  @override
  Widget build(BuildContext context) {
    const int _blackPrimaryValue = 0xFF000000;
    const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
// const MaterialColor white = const MaterialColor(
//   0xFFFFFFFF,
//   const <int, Color>{
//     50: const Color(0xFFFFFFFF),
//     100: const Color(0xFFFFFFFF),
//     200: const Color(0xFFFFFFFF),
//     300: const Color(0xFFFFFFFF),
//     400: const Color(0xFFFFFFFF),
//     500: const Color(0xFFFFFFFF),
//     600: const Color(0xFFFFFFFF),
//     700: const Color(0xFFFFFFFF),
//     800: const Color(0xFFFFFFFF),
//     900: const Color(0xFFFFFFFF),
//   },
// );

    
    return  ChangeNotifierProvider(
      create: (context)=>TodoProvider(),
          child: MaterialApp(
      
        debugShowCheckedModeBanner: false,
        
        theme: ThemeData(
             primarySwatch:primaryBlack,
             accentColor: Colors.grey,
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ))),
        home: FutureBuilder(
          future:
              // Hive.openBox('todo'),
              openingBox(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else
                return TodoScreen();
            } else
              return TodoScreen();

            
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
