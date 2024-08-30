import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_page.dart';

class ImageDescGenPage extends StatefulWidget {
  @override
  _ImageDescGenPageState createState() => _ImageDescGenPageState();
}

class _ImageDescGenPageState extends State<ImageDescGenPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};
  String? _imagePath;
  bool _isLoading = false;

  String? _description;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      try {
        // Make API call
        final response = await http.post(
          Uri.parse('https://api.example.com/submit'),
          body: json.encode(_formData),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            _imagePath = responseData['imagePath'];
          });
        } else {
          // Handle error
          print('API call failed');
        }
      } catch (error) {
        print('Error occurred: $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Generate Image based on Options',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 5,
              onSaved: (value) {
                _description = value;
                _formData['description'] = value!;
              },
            ),
            SizedBox(height: 36),
            ElevatedButton(
              onPressed: _submitForm,
              child: _isLoading ? CircularProgressIndicator() : Text('Submit'),
            ),
            if (_imagePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.network(
                  _imagePath!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
