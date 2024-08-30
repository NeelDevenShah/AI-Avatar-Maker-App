import 'package:flutter/material.dart';
import 'base_page.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Gallery',
      body: ListView.builder(
        itemCount: 10, // Replace with your actual image list length
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.image),
            title: Text('Image $index'),
            onTap: () {
              // Handle image tap
            },
          );
        },
      ),
    );
  }
}
