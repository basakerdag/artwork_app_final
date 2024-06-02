import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/logo.jpeg'), // Logonuzun dosya yolu
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Contact Information',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1')
              ElevatedButton(
                onPressed: () {
                  _showAddContactDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('+ Add Contact', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            const SizedBox(height: 20),
            _buildContactList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('contact').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
        }
        final data = snapshot.data?.docs ?? [];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final contactData = data[index].data() as Map<String, dynamic>;
            final email = contactData['email'] ?? '';
            final phone = contactData['phone'] ?? '';
            final address = contactData['address'] ?? '';
            final contactUid = data[index].id;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.white.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildContactItem(Icons.email, email),
                    _buildContactItem(Icons.phone, phone),
                    _buildContactItem(Icons.location_on, address),
                    if (currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1')
                      const SizedBox(height: 16),
                    if (currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1')
                      ElevatedButton(
                        onPressed: () {
                          _deleteContact(contactUid, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Text('Delete Contact', style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContactItem(IconData iconData, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: Colors.black, size: 24),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Contact', style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: phoneController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(labelText: 'Phone', labelStyle: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: addressController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(labelText: 'Address', labelStyle: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                _addContactToFirestore(
                  emailController.text,
                  phoneController.text,
                  addressController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _addContactToFirestore(String email, String phone, String address) {
    FirebaseFirestore.instance.collection('contact').add({
      'email': email,
      'phone': phone,
      'address': address,
      'uid': currentUserUid,
      'timestamp': Timestamp.now(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact added successfully.'),
        ),
      );
    }).catchError((error) {
      print('Error adding contact: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error adding contact.'),
        ),
      );
    });
  }

  void _deleteContact(String contactUid, BuildContext context) {
    FirebaseFirestore.instance.collection('contact').doc(contactUid).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact deleted successfully.'),
        ),
      );
    }).catchError((error) {
      print('Error deleting contact: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting contact.'),
        ),
      );
    });
  }
}
