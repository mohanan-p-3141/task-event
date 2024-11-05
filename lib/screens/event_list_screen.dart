import 'package:flutter/material.dart';
import '../models/event.dart';
import 'event_detail_screen.dart';

class EventListScreen extends StatelessWidget {
  final List<Event> events = [
    Event(
      title: 'Flutter Workshop',
      date: '2024-12-01',
      location: 'Online',
      time: '10:00 AM - 2:00 PM',
      description: 'Learn Flutter basics.',
      agenda: 'Introduction, Flutter Basics, UI Design',
    ),
    Event(
      title: 'Tech Conference',
      date: '2024-12-10',
      location: 'Online',
      time: '10:00 AM - 2:00 PM',
      description: 'Explore the latest in tech.',
      agenda: 'Introduction, Trends in Tech, Future of tech ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 16, 75, 177), Color.fromARGB(174, 10, 112, 159)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(event.date,
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 8),
                    Text(event.description,
                        style: TextStyle(fontSize: 14)), // Add event description here
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        child: Text('JOIN'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  EventDetailScreen(event: event),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                // Slide Transition
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
