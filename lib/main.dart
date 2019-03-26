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
  @override

  List<String> _todoItems = [];

  void _addTodo(){ //Used to add items whenever button is pressed
    setState(() {
      int index = _todoItems.length;
      _todoItems.add('Item '+index.toString());
    });
  }

  Widget _buildList (){
    return new ListView.builder(
        itemBuilder: (context, index) {
          // itemBuilder will be automatically be called as many times as it takes for the
          // list to fill up its available space, which is most likely more than the
          // number of todo items we have. So, we need to check the index is OK.
          if (index < _todoItems.length) {
            return _buildTodoItem(_todoItems[index]);
          }
        }
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText) {
      return new ListTile(
          title: new Text(todoText)
      );
  }

  Widget build(BuildContext build){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo List'),
      ),
      body: _buildList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _addTodo,
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
    );
  }
}