import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_hive/models/todo_model.dart';
import 'package:todo_app_hive/services/todo_services.dart';

//main screen / homepage
class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  //creating object for todoservice
  final ToDoService _toDoService = ToDoService();

  @override
  Widget build(BuildContext context) {
    //creating textediting controller
    TextEditingController getDescription = TextEditingController();

    //giving background
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 75, 230, 109), Color.fromARGB(255, 95, 175, 240)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      
      child: Scaffold(
        //background color = transparent so that container color will be visible
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          //background color = transparent so that container color will be visible
          backgroundColor: Colors.transparent,
          title: const Center(
            child: Text('TODO',
              style: TextStyle(
                //available at : lib\assets\Teko-Bold.ttf
                fontFamily: 'Teko',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
        ),
        body: Center(
          child: ValueListenableBuilder(
              valueListenable: Hive.box<ToDoModel>('todoBox').listenable(),
              // the third parameter is intentionally unused in builder
              builder: (context, Box<ToDoModel> box, _) {
                return ListView.builder(
                  //getting item count
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    var todoItem = box.getAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      //creating list tiles
                      child: ListTile(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.4)
                          )
                        ),
                        //Assume todoItem is not null
                        title: Text(todoItem!.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontFamily: 'Teko',
                            fontSize: 30,
                          ),
                        ),
                        leading: Checkbox(
                          fillColor: MaterialStateProperty.all(Colors.white),
                          //activeColor: Colors.white,
                          checkColor: Colors.blue,
                          //gives boolean value
                            value: todoItem.isCompleted,
                            onChanged: (val) {
                              _toDoService.updateToDo(index, todoItem);
                            },),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _toDoService.deleteToDoItem(index);
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
        ),

        //creating floating action button
        floatingActionButton: FloatingActionButton(
          //shape -> circle
          shape: const CircleBorder(),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {

                //onpressed -> gives AlertDialog which has a textfield and a button
                return AlertDialog(
                  title: const Text('Add Todo'),
                  content: TextField(
                    controller: getDescription,
                    decoration: const InputDecoration(
                      //focusColor: Color.fromARGB(255, 95, 175, 240),
                      hintText: 'Enter your to-do',
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        var todoItem = ToDoModel(getDescription.text);
                        _toDoService.addItem(todoItem);
                        getDescription.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add',
                        style: TextStyle(
                          color: Color.fromARGB(255, 95, 175, 240)
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add,
            color: Color.fromARGB(255, 95, 175, 240),
            size: 40,
          ),
        ),
      ),
    );
  }
}
