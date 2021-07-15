import 'package:flutter/material.dart';
import 'package:todo_editor/editor_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Mongol Editor',
      home: Scaffold(body: EditorPage()),
    );
  }
}
