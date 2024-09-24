import 'package:flutter/material.dart';
import 'base_page.dart'; // Import the BasePage class
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // Import for jsonDecode

// Initialize secure storage
const storage = FlutterSecureStorage();

class UserPage extends StatelessWidget {
  final String apiUrl = '${Config.baseUrl}/auth/users/me';

  Future<Map<String, dynamic>> fetchUser() async {
    final String? token = await storage.read(key: 'token');

    if (token != null) {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Parse the JSON response
      } else {
        throw Exception('Failed to load user data'); // Handle errors
      }
    } else {
      throw Exception('No token found'); // Handle case where token is null
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'User Profile',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show loading indicator
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Handle error
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'User Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildUserInfoRow('First Name', user['first_name'] ?? 'N/A'),
                  const SizedBox(height: 10),
                  _buildUserInfoRow('Last Name', user['last_name'] ?? 'N/A'),
                  const SizedBox(height: 10),
                  _buildUserInfoRow('Email', user['email'] ?? 'N/A'),
                  const SizedBox(height: 10),
                  _buildUserInfoRow('Phone Number', user['mobile'] ?? 'N/A'),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container(); // Fallback case
          },
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
