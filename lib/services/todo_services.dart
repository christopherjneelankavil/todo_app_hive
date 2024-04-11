import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_hive/models/todo_model.dart';

class ToDoService{
  //db name
  final String _boxName="todoBox";

  //creating db
  Future<Box<ToDoModel>> get _box async=> await  Hive.openBox<ToDoModel>(_boxName);


  //Adding data 
  Future <void> addItem(ToDoModel toDoModel)async{
    var todoBox=await _box;
    todoBox.add(toDoModel);
  }

  //get all todo(s)

  Future<List<ToDoModel>> getTodoList() async{
    var todoBox = await _box;
    return todoBox.values.toList();
  }

  //delete todo

  Future<void> deleteToDoItem(int index) async{
    var todoBox = await _box;
    //delete item at a specific index
    await todoBox.deleteAt(index);
  }
  
  //Update todo item
  Future<void> updateToDo(int index,ToDoModel toDoModel) async{
    var todoBox=await _box;
    toDoModel.isCompleted = !toDoModel.isCompleted;
    await todoBox.putAt(index, toDoModel);
  }
}