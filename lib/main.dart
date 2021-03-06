import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

DataRepository repo = new DataRepository();

class DataRepository {
  List<Project> projects;
  DataRepository() {
    init();
  }
  init() {
    projects = new List<Project>()
      ..add(new Project("Project 1", "Description 1"))
      ..add(new Project("Project 2", "Description 2"))
      ..add(new Project("Project 3", "Description 3"));
  }
}

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

class HomeRoute extends StatelessWidget {
  final _title = "Home";
  final _projects = repo.projects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text(this._title),
        ),
      body: new SortableListView(
          items: this._projects,
          itemBuilder: (_, int index) => new Card(
                child: new ListTile(
                  leading: new Icon(Icons.photo),
                  title: new Text(this._projects[index].title),
                  subtitle: new Text(this._projects[index].description),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute<Null>(
                        settings: const RouteSettings(name: "/tasks"),
                        builder: (BuildContext context) => TaskListPage(this._projects[index]),
                      ),
                    );
                  },
                ),
              ),
        ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add Project',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProject()),
            );
          },
        ),
    );
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final title = 'Project ListView';

    return new MaterialApp(
      title: title,
      home: new HomeRoute(),
      routes: {
        '/tasks': (BuildContext context) => TaskListPage(new Project('', '')),
      },
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
class EditProject extends StatefulWidget {
  @override
  _EditProjectState createState() => new _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  Project _project = new Project('', '');
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 3))
        .then((value) => handleTimeout());
  }

  void _addProject() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      repo.projects.add(this._project);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Project"),
      ),
      body: Form(
        key: this._formKey,
        child: new ListView(
          children: <Widget>[
            new TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                  hintText: 'ピカチュウ・ザ・ムービー',
                  labelText: 'プロジェクト名'
              ),
              onSaved: (String title) {
                this._project.title = title;
              },
            ),
            new TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                  hintText: '劇場版ポケットモンスタープロジェクト名のこと',
                  labelText: '説明'
              ),
              onSaved: (String description) {
                this._project.description = description;
              },
            ),
            new Container(
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(
                  '追加',
                  style: new TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: () => this._addProject(),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      )
    );
  }

  void handleTimeout() {
  }
}

class EditTask extends StatefulWidget {
  List<Task> _tasks;
  EditTask(List<Task> tasks) {
    this._tasks = tasks;
  }
  @override
  _EditTaskState createState() => new _EditTaskState(this._tasks);
}


class _EditTaskState extends State<EditTask> {
  List<Task> _tasks;
  Task _task = new Task('', '');
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _EditTaskState(List<Task> tasks) {
    this._tasks = tasks;
  }

  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 3))
        .then((value) => handleTimeout());
  }

  void _addTask() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      this._tasks.add(this._task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Project"),
      ),
      body: Form(
        key: this._formKey,
        child: new ListView(
          children: <Widget>[
            new TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                  hintText: '早起きをする',
                  labelText: 'タスク名'
              ),
              onSaved: (String title) {
                this._task.title = title;
              },
            ),
            new TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                  hintText: '毎朝６時には起きること',
                  labelText: '説明'
              ),
              onSaved: (String description) {
                this._task.description = description;
              },
            ),
            new Container(
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(
                  '追加',
                  style: new TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: () => this._addTask(),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      )
    );
  }

  void handleTimeout() {
  }
}

class TaskListPage extends StatelessWidget {
  List<Task> _tasks;
  TaskListPage(Project project) {
    this._tasks = project.tasks;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: new SortableListView(
          items: this._tasks,
          itemBuilder: (_, int index) => new Card(
                child: new ListTile(
                  leading: new Icon(Icons.photo),
                  title: new Text(this._tasks[index].title),
                  subtitle: new Text(this._tasks[index].description),
                  onTap: () {
                  },
                ),
              ),
        ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add Task',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditTask(this._tasks)),
            );
          },
        ),
    );
  }
}