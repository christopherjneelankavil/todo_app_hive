import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'todo_model.g.dart';

//Database model
@HiveType(typeId: 1)
class ToDoModel{
  //assigning fields
  @HiveField(0)
  final String description;

  @HiveField(1)
  bool isCompleted;
  //constructor
  ToDoModel(this.description,{this.isCompleted=false});
}