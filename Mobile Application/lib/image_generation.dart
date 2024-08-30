import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_page.dart';

class ImageGenerationPage extends StatefulWidget {
  @override
  _ImageGenerationPageState createState() => _ImageGenerationPageState();
}

class _ImageGenerationPageState extends State<ImageGenerationPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};
  String? _imagePath;
  bool _isLoading = false;

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
      title: 'Generate Image 12',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
              onSaved: (value) => _formData['age'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Gender'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your gender';
                }
                return null;
              },
              onSaved: (value) => _formData['gender'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Ethnicity'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your ethnicity';
                }
                return null;
              },
              onSaved: (value) => _formData['ethnicity'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Skin Tone'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your skin tone';
                }
                return null;
              },
              onSaved: (value) => _formData['skin_tone'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Body Type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your body type';
                }
                return null;
              },
              onSaved: (value) => _formData['body_type'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Hair Colour'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your hair color';
                }
                return null;
              },
              onSaved: (value) => _formData['hair_colour'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Clothing Top'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your clothing top';
                }
                return null;
              },
              onSaved: (value) => _formData['clothing_top'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Clothing Bottom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your clothing bottom';
                }
                return null;
              },
              onSaved: (value) => _formData['clothing_bottom'] = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onSaved: (value) => _formData['description'] = value!,
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
            if (_imagePath != null)
              Image.network(
                _imagePath!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
