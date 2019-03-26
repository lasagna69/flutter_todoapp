// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(new TodoApp());

// Every component in Flutter is a widget, even the whole app itself
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new Scaffold(
          appBar: new AppBar(
              title: new Text('Todo List')
          )
      ),
    );
  }
}

class TodoList extends StatefulWidget{
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList>{
  List<String> _todoItems = [];

  void _addTodo(String task){ //Used to add items whenever button is pressed
    // Only add the task if the user actually entered something
    if(task.length > 0) {
      setState(() => _todoItems.add(task));// notifies the app that the state has changed by using setState
    }
  }

   void _removeTodo(int index) {// Much like _addTodo, this modifies the array of todo strings
    setState(() => _todoItems.removeAt(index));// notifies the app that the state has changed by using setState
  }

  // Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${_todoItems[index]}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()
                ),
                new FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodo(index);
                      Navigator.of(context).pop();
                    }
                )
              ]
          );
        }
    );
  }

  Widget _buildList (){
    return new ListView.builder(
        itemBuilder: (context, index) {
          // itemBuilder will be automatically be called as many times as it takes for the
          // list to fill up its available space, which is most likely more than the
          // number of todo items we have. So, we need to check the index is OK.
          if (index < _todoItems.length) {
            return _buildTodoItem(_todoItems[index], index);
          }
        }
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText, int index) {
      return new ListTile(
          title: new Text(todoText),
          onTap: () => _promptRemoveTodoItem(index)
      );
  }

  @override
  Widget build(BuildContext build){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo List'),
      ),
      body: _buildList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen, // pressing this button now opens the new screen
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
    );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  appBar: new AppBar(
                      title: new Text('Add a new task')
                  ),
                  body: new TextField(
                    autofocus: true,
                    onSubmitted: (val) {
                      _addTodo(val);
                      Navigator.pop(context); // Close the add todo screen
                    },
                    decoration: new InputDecoration(
                        hintText: 'Enter something to do...',
                        contentPadding: const EdgeInsets.all(16.0)
                    ),
                  )
              );
            }
        )
    );
}