import 'package:flutter/material.dart';
import 'screens/event_list_screen.dart';

void main() {
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EventListScreen(),
    );
  }
}
