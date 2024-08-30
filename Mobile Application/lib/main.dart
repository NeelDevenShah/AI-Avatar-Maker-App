import 'package:flutter/material.dart';
import 'home.dart';
import 'gallery.dart';
import 'image_generation.dart';
import 'image_desc_generation.dart';
import 'signup.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Set the initial route to '/login'
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/generate-options': (context) => ImageGenerationPage(),
        '/generate-desc': (context) => ImageDescGenPage(),
        '/gallery': (context) => GalleryPage(),
      },
    );
  }
}
