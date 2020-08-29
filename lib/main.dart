import 'package:flutter/material.dart';
import 'package:flutter_assingment/screens/swipe_list_view_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe ListView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SwipeListViewScreen(),
    );
  }
}
