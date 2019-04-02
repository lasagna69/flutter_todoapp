import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_todo/actions.dart';
import 'package:flutter_todo/state.dart';
import 'package:flutter_todo/to_do_item.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class ToDoListPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Todo List',
        home: new ToDoList()
    );
  }
}

class ToDoList extends StatefulWidget{
  @override
  createState() => new ToDoListState();
}

class ToDoListState extends State<ToDoList>{
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
    converter: (Store<AppState> store) => _ViewModel.create(store),
    builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
      appBar: AppBar(
        title: Text(viewModel.pageTitle),
      ),
      body: ListView(children: viewModel.items.map((_ItemViewModel item) => _createWidget(item)).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.onAddItem,
        tooltip: viewModel.newItemToolTip,
        child: Icon(viewModel.newItemIcon),
      ),
    ),
  );

  Widget _createWidget(_ItemViewModel item) {
    if (item is _EmptyItemViewModel) {
      return _createEmptyItemWidget(item);
    } else {
      return _createToDoItemWidget(item);
    }
  }

  Widget _createEmptyItemWidget(_EmptyItemViewModel item) => Column(
    children: [
      TextField(
        //onSubmitted: item.onCreateItem,
//        autofocus: true,
        decoration: InputDecoration(
          hintText: item.createItemToolTip,
        ),
      ),
      DateTimePickerFormField(
        inputType: inputType,
        format: formats[inputType],
        editable: editable,
        decoration: InputDecoration(
            labelText: 'Date/Time', hasFloatingPlaceholder: false),
        onChanged: (dt) => setState(() => date = dt),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) {
            return RaisedButton(
              onPressed: () => submitTodo(item),
              color: Colors.indigoAccent,
              child: Text('Submit Todo'),
            );
          },
        ),
      ),
    ],
  );

  Widget _createToDoItemWidget(_ToDoItemViewModel item) => Row(
    children: [
      Text(item.title),
      FlatButton(
        onPressed: item.onDeleteItem,
        child: Icon(
          item.deleteItemIcon,
          semanticLabel: item.deleteItemToolTip,
        ),
      )
    ],
  );
  void submitTodo(_EmptyItemViewModel item) {
    item.onCreateItem;
  }
}

class _ViewModel {
  final String pageTitle;
  final List<_ItemViewModel> items;
  final Function() onAddItem;
  final String newItemToolTip;
  final IconData newItemIcon;

  _ViewModel(this.pageTitle, this.items, this.onAddItem, this.newItemToolTip, this.newItemIcon);

  factory _ViewModel.create(Store<AppState> store) {
    List<_ItemViewModel> items = store.state.toDos
        .map((ToDoItem item) => _ToDoItemViewModel(item.title, () {
      store.dispatch(RemoveItemAction(item));
      store.dispatch(SaveListAction());
    }, 'Delete', Icons.delete) as _ItemViewModel)
        .toList();

    if (store.state.listState == ListState.listWithNewItem) {
      items.add(_EmptyItemViewModel('Type the next task here', (String title, DateTime date) {
        store.dispatch(DisplayListOnlyAction());
        store.dispatch(AddItemAction(ToDoItem(title, date)));
        store.dispatch(SaveListAction());
      }, 'Add'));
    }

    return _ViewModel('To Do', items, () => store.dispatch(DisplayListWithNewItemAction()), 'Add new to-do item', Icons.add);
  }



}

abstract class _ItemViewModel {}

@immutable
class _EmptyItemViewModel extends _ItemViewModel {
  final String hint;
  final Function(String, DateTime) onCreateItem;
  final String createItemToolTip;

  _EmptyItemViewModel(this.hint, this.onCreateItem, this.createItemToolTip);
}

@immutable
class _ToDoItemViewModel extends _ItemViewModel {
  final String title;
  final Function() onDeleteItem;
  final String deleteItemToolTip;
  final IconData deleteItemIcon;

  _ToDoItemViewModel(this.title, this.onDeleteItem, this.deleteItemToolTip, this.deleteItemIcon);
}
