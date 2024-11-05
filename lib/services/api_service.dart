import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Simulate RSVP with name and email
  Future<bool> submitRSVP(String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'), // Use 'posts' endpoint as a placeholder
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        // Success (Created)
        return true;
      } else if (response.statusCode == 400) {
        throw Exception('Validation error: Invalid input.');
      } else {
        throw Exception('Failed to submit RSVP. Please try again.');
      }
    } catch (e) {
      throw Exception('Network error: Unable to submit RSVP. Check your connection.');
    }
  }

  // Check if the email already exists in the attendees list
  Future<bool> checkEmailExists(String email) async {
    try {
      // Replace this URL with your actual endpoint that checks for existing emails
      final response = await http.get(
        Uri.parse('$baseUrl/posts'), // Placeholder for the actual endpoint
      );

      if (response.statusCode == 200) {
        // Assuming the response contains a list of attendees
        final List<dynamic> attendees = jsonDecode(response.body);

        // Check if the email exists in the list
        return attendees.any((attendee) => attendee['email'] == email);
      } else {
        throw Exception('Failed to check email existence. Please try again.');
      }
    } catch (e) {
      throw Exception('Network error: Unable to check email existence. Check your connection.');
    }
  }
}
