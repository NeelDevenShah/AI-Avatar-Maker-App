import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;

  BasePage({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Generate Image based on Options'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/generate-options');
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Generate Image based on Description'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/generate-desc');
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/gallery');
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
