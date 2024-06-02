import 'package:flutter/material.dart';
import 'package:artwork_app/features/auth/views/product/Drawings/drawings.dart';
import 'package:artwork_app/features/auth/views/product/Photography/photography.dart';
import 'package:artwork_app/features/auth/views/product/Sculpture/sculpture.dart';
import 'package:artwork_app/features/auth/views/product/Paintings/paintings.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.9), // White with less opacity
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOption(context, 'Paintings', Icons.palette, Colors.pink, Paintings()),
              const SizedBox(height: 20),
              _buildOption(context, 'Photography', Icons.camera, Colors.pink, Photography()),
              const SizedBox(height: 20),
              _buildOption(context, 'Drawings', Icons.edit, Colors.pink, Drawings()),
              const SizedBox(height: 20),
              _buildOption(context, 'Sculpture', Icons.sentiment_satisfied, Colors.pink, Sculpture()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String option, IconData icon, Color iconColor, Widget page) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      icon: Icon(icon, color: iconColor),
      label: Text(
        option,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Button text color
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Button background color
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded button corners
        ),
        shadowColor: Colors.pink.withOpacity(0.2), // Button shadow
        elevation: 5, // Button elevation
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProductPage(),
  ));
}
