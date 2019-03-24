import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class Project {
  String title;
  String description;
  List<Task> tasks;
  DateTime createdAt;
  DateTime updatedAt;

  Project(String title, String description) {
    this.title = title;
    this.description = description;
    this.tasks = new List<Task>()
      ..add(new Task("Task 1", "Description 1"))
      ..add(new Task("Task 2", "Description 2"));
    this.createdAt = new DateTime.now();
    this.updatedAt = new DateTime.now();
  }
}

class Task {
  String title;
  String description;
  Status status;
  DateTime createdAt;
  DateTime updatedAt;

  Task(String title, String description) {
    this.title = title;
    this.description = description;
    this.status =Status.Todo;
    this.createdAt = new DateTime.now();
    this.updatedAt = new DateTime.now();
  }
}

enum Status {
  Todo,
  Doing,
  Done,
  Close
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Project> projects = new List<Project>()
    ..add(new Project("Project 1", "Description 1"))
    ..add(new Project("Project 2", "Description 2"));

  @override
  Widget build(BuildContext context) {
    final title = 'Project ListView';

    return new MaterialApp(
      title: title,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new SortableListView(
          items: projects,
          itemBuilder: (_, int index) => new Card(
                child: new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text(projects[index].title),
                    subtitle: new Text(projects[index].description)),
              ),
        ),
      ),
    );
  }
}
class SortableListView extends StatefulWidget {
  final List items;
  final IndexedWidgetBuilder itemBuilder;

  SortableListView({this.items, this.itemBuilder})
      : assert(items != null),
        assert(itemBuilder != null);

  @override
  State createState() => new SortableListViewState();
}

class SortableListViewState extends State<SortableListView> {
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (context, constraint) {
        return new ListView.builder(
          itemCount: widget.items.length + 1,
          addRepaintBoundaries: true,
          itemBuilder: (context, index) {
            return new LongPressDraggable<int>(
              data: index,
              child: new DragTarget<int>(
                onAccept: (int data) {
                  _handleAccept(data, index);
                },
                builder: (BuildContext context, List<int> data,
                    List<dynamic> rejects) {
                  List<Widget> children = [];
                  if (data.isNotEmpty) {
                    children.add(
                      new Container(
                        decoration: new BoxDecoration(
                          border: new Border.all(
                              color: Colors.grey[600], width: 2.0),
                        ),
                        child: new Opacity(
                          opacity: 0.5,
                          child: _getListItem(context, data[0]),
                        ),
                      ),
                    );
                  }
                  children.add(_getListItem(context, index));

                  return new Column(
                    children: children,
                  );
                },
              ),
              onDragStarted: () {
                Scaffold.of(context).showSnackBar(
                      new SnackBar(
                          content: new Text("Drag the row to change places")),
                    );
              },
              feedback: new Opacity(
                opacity: 0.75,
                child: new SizedBox(
                  width: constraint.maxWidth,
                  child: _getListItem(context, index, true),
                ),
              ),
              childWhenDragging: new Container(),
            );
          },
        );
      },
    );
  }

  void _handleAccept(int data, int index) {
    setState(() {
      if (index > data) {
        index--;
      }
      dynamic imageToMove = widget.items[data];
      widget.items.removeAt(data);
      widget.items.insert(index, imageToMove);
    });
  }

  Widget _getListItem(BuildContext context, int index, [bool dragged = false]) {
    if (index == widget.items.length) {
      if (widget.items.isEmpty) {
        return new Container();
      }
      return new Opacity(
        opacity: 0.0,
        child: _getListItem(context, index - 1),
      );
    }
    return new Material(
      elevation: dragged ? 20.0 : 0.0,
      child: widget.itemBuilder(context, index),
    );
  }
}