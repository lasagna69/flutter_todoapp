class ToDoItem {
  final String title;
  final DateTime date;

  ToDoItem(this.title, this.date);

  @override
  bool operator ==(Object other) => identical(this, other) || other is ToDoItem && runtimeType == other.runtimeType && title == other.title;

  @override
  int get hashCode => title.hashCode;
}
