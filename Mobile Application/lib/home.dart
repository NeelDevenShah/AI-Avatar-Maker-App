import 'package:flutter/material.dart';
import 'base_page.dart'; // Import the BasePage class

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Home',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the AI Avatar Maker!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Create your own personalized avatar using artificial intelligence.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
