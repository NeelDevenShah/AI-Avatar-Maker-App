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

  // Define options for dropdowns
  final List<String> _genders = ['Male', 'Female', 'Non-binary', 'Other'];
  final List<String> _ethnicities = [
    'Asian',
    'Black',
    'Caucasian',
    'Hispanic',
    'Other'
  ];
  final List<String> _skinTones = ['Light', 'Medium', 'Dark'];
  final List<String> _bodyTypes = ['Slim', 'Average', 'Athletic', 'Heavy'];
  final List<String> _hairColors = ['Black', 'Brown', 'Blonde', 'Red', 'Other'];
  final List<String> _clothingTops = [
    'Casual',
    'Formal',
    'Sportswear',
    'Other'
  ];
  final List<String> _clothingBottoms = [
    'Jeans',
    'Shorts',
    'Skirt',
    'Trousers'
  ];

  String? _selectedGender;
  String? _selectedEthnicity;
  String? _selectedSkinTone;
  String? _selectedBodyType;
  String? _selectedHairColor;
  String? _selectedClothingTop;
  String? _selectedClothingBottom;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _selectedGender,
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                    _formData['gender'] = newValue!;
                  });
                },
                items: _genders.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your gender' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Ethnicity',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _selectedEthnicity,
                onChanged: (newValue) {
                  setState(() {
                    _selectedEthnicity = newValue;
                    _formData['ethnicity'] = newValue!;
                  });
                },
                items: _ethnicities.map((ethnicity) {
                  return DropdownMenuItem(
                    value: ethnicity,
                    child: Text(ethnicity),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your ethnicity' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Skin Tone',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _selectedSkinTone,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSkinTone = newValue;
                    _formData['skin_tone'] = newValue!;
                  });
                },
                items: _skinTones.map((skinTone) {
                  return DropdownMenuItem(
                    value: skinTone,
                    child: Text(skinTone),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your skin tone' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Body Type',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _selectedBodyType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBodyType = newValue;
                    _formData['body_type'] = newValue!;
                  });
                },
                items: _bodyTypes.map((bodyType) {
                  return DropdownMenuItem(
                    value: bodyType,
                    child: Text(bodyType),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your body type' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Hair Color',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _selectedHairColor,
                onChanged: (newValue) {
                  setState(() {
                    _selectedHairColor = newValue;
                    _formData['hair_colour'] = newValue!;
                  });
                },
                items: _hairColors.map((hairColor) {
                  return DropdownMenuItem(
                    value: hairColor,
                    child: Text(hairColor),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your hair color' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Clothing Top',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _selectedClothingTop,
                onChanged: (newValue) {
                  setState(() {
                    _selectedClothingTop = newValue;
                    _formData['clothing_top'] = newValue!;
                  });
                },
                items: _clothingTops.map((clothingTop) {
                  return DropdownMenuItem(
                    value: clothingTop,
                    child: Text(clothingTop),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your clothing top' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Clothing Bottom',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _selectedClothingBottom,
                onChanged: (newValue) {
                  setState(() {
                    _selectedClothingBottom = newValue;
                    _formData['clothing_bottom'] = newValue!;
                  });
                },
                items: _clothingBottoms.map((clothingBottom) {
                  return DropdownMenuItem(
                    value: clothingBottom,
                    child: Text(clothingBottom),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select your clothing bottom' : null,
              ),
              SizedBox(height: 36),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
              if (_imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Image.network(
                      _imagePath!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
