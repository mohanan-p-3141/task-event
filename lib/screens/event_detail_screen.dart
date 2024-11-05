import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/api_service.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _submitRSVP() async {
    if (_formKey.currentState!.validate()) {
      final enteredEmail = _emailController.text;
      final enteredName = _nameController.text;

      // Check if the email already exists in attendees via API
      bool emailExist = await _apiService.checkEmailExists(enteredEmail);
      if (emailExist) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User already exists!')),
        );
        return; // Exit early if the user is already registered
      }

      try {
        bool success = await _apiService.submitRSVP(
          enteredName,
          enteredEmail,
        );

        if (success) {
          setState(() {
            widget.event.attendees
                .add(enteredName); // Add name to attendees list
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('WELCOME TO THE EVENT!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event.title)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 16, 75, 177),
              Color.fromARGB(174, 10, 112, 159),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.date,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              widget.event.description,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),

            // New Event Details Section
            Text(
              'Location: ${widget.event.location}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              'Time: ${widget.event.time}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              'Agenda: ${widget.event.agenda}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter your name';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@'))
                        return 'Enter a valid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  AnimatedButton(
                    onPressed: _submitRSVP,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 202, 129, 19),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Attendees:',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              itemCount: widget.event.attendees.length,
              itemBuilder: (context, index) {
                return Text(
                  widget.event.attendees[index],
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// AnimatedButton class remains the same
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const AnimatedButton({required this.child, required this.onPressed});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse(); // Shrink the button
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward(); // Return to normal size
    widget.onPressed(); // Trigger the onPressed function
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (details) {
        _onTapUp(details);
      },
      onTapCancel: _controller.forward,
      child: ScaleTransition(
        scale: _controller,
        child: widget.child,
      ),
    );
  }
}
