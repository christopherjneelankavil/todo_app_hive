import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:todo_app_hive/screens/todo_screen.dart';
import 'package:todo_app_hive/services/todo_services.dart';

void main() async {
  //initializing hive db
  await Hive.initFlutter();

  //registering hive
  Hive.registerAdapter(ToDoModelAdapter());
  //run
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ToDoService _toDoService = ToDoService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
      home: FutureBuilder(
        future: _toDoService.getTodoList(),
        //from flutter documentation of Future builder
        builder:  (BuildContext context, AsyncSnapshot<List<ToDoModel>> snapshot){
          //checking whether data is ready
          if(snapshot.connectionState == ConnectionState.done){
            return const ToDoScreen();
          }
          //if not
          else{
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
