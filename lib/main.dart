import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const kContacts = const <Contact>[
    const Contact(
      fullName: 'Romain Hoogmoed',
      email:'romain.hoogmoed@example.com'
    ),
    const Contact(
      fullName: 'Emilie Olsen',
      email:'emilie.olsen@example.com'
    )
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: new ContactsPage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Material App"),
        ),
        body: ListView(
            children: List.generate(10, (index) {
          return InkWell(
            onTap: () {
            },
            child: Card(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/screen_01.png"),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text("screen_01.png"),
                        leading: Icon(Icons.person),
                        subtitle: Text("サブタイトル"),
                      )),
                ],
              ),
            ),
          );
        })));
  }
}

class Contact {
  final String fullName;
  final String email;

  const Contact({this.fullName, this.email});
}

class _ContactListItem extends StatelessWidget {
  final Contact _contact;
  bool isSelected = false;

  _ContactListItem(this._contact);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate page
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(_contact.fullName),
              leading: Image.asset("assets/screen_01.png", height: 50),
              subtitle: Text(_contact.email),
            )),
          ],
        ),
      )
    );
  }
}

class ContactList extends StatelessWidget {

  final List<Contact> _contacts;

  ContactList(this._contacts);

  @override
  Widget build(BuildContext context) {
    return ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: _buildContactList()
        );
  }

  List<_ContactListItem> _buildContactList() {
    return _contacts.map((contact) => _ContactListItem(contact))
                    .toList();
  }

}

class ContactsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Contacts"),
        ),
        body: ContactList(kContacts)
      );
  }

}
