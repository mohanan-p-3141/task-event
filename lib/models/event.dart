class Event {
  final String title;
  final String date;
  final String ?location;
  final String ?time;
  final String description;
  final String ? agenda;
  List<String> attendees;

  Event({
    required this.title,
    required this.date,
    this.location,
    this.time,
    required this.description,
    this.agenda,
    List<String>? attendees ,

  }) : attendees = attendees ?? [];
}
