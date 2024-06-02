import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:artwork_app/features/auth/views/artists/artistsDetailPage.dart';

class ArtistsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artists Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('artists').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<DocumentSnapshot> artists = snapshot.data!.docs;

            return ListView.builder(
              itemCount: artists.length,
              itemBuilder: (context, index) =>
                  _buildArtistCard(context, artists[index]),
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildArtistCard(BuildContext context, DocumentSnapshot artistSnapshot) {
    final artist = artistSnapshot.data() as Map<String, dynamic>;
    final String artistName = artist['artistName'] ?? '';
    final String country = artist['country'] ?? '';
    final String information = artist['information'] ?? '';
    final String artistPhotoName = artist['artistPhotoName'] ?? '';
    final String artworkName = artist['artworkName'] ?? '';
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: artistPhotoName.isNotEmpty
            ? CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('assets/images/$artistPhotoName'),
              )
            : CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
        title: Text(
          artistName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          country,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ),
        trailing: currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      _deleteArtist(context, artistSnapshot.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.blue,
                    onPressed: () {
                      _editArtist(context, artistSnapshot);
                    },
                  ),
                ],
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistDetailPage(
                artistName: artistName,
                country: country,
                artistPhotoName: artistPhotoName,
                information: information,
                artworkName: artworkName,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null &&
        currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1') {
      return FloatingActionButton(
        onPressed: () {
          _addNewArtist(context);
        },
        child: const Icon(Icons.add),
      );
    } else {
      return Container();
    }
  }

  void _addNewArtist(BuildContext context) {
    String artistName = '';
    String country = '';
    String information = '';
    String artistPhotoName = '';
    String artworkName = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Artist'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Artist Name'),
                onChanged: (value) {
                  artistName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Country'),
                onChanged: (value) {
                  country = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Information'),
                onChanged: (value) {
                  information = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Artist Photo Name'),
                onChanged: (value) {
                  artistPhotoName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Artwork Name'),
                onChanged: (value) {
                  artworkName = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (artistName.isNotEmpty &&
                  country.isNotEmpty &&
                  information.isNotEmpty &&
                  artistPhotoName.isNotEmpty &&
                  artworkName.isNotEmpty) {
                _uploadArtistToFirestore(context, artistName, country,
                    information, artistPhotoName, artworkName);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter all the details.'),
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _uploadArtistToFirestore(BuildContext context, String artistName,
      String country, String information, String artistPhotoName,
      String artworkName) async {
    try {
      await FirebaseFirestore.instance.collection('artists').add({
        'artistName': artistName,
        'country': country,
        'information': information,
        'artistPhotoName': artistPhotoName,
        'artworkName': artworkName,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Artist added successfully.'),
        ),
      );
    } catch (e) {
      print('Error adding artist: $e');
    }
  }

  void _editArtist(BuildContext context, DocumentSnapshot artistSnapshot) {
    final artist = artistSnapshot.data() as Map<String, dynamic>;
    String artistName = artist['artistName'] ?? '';
    String country = artist['country'] ?? '';
    String information = artist['information'] ?? '';
    String artistPhotoName = artist['artistPhotoName'] ?? '';
    String artworkName = artist['artworkName'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Artist'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Artist Name'),
                controller: TextEditingController(text: artistName),
                onChanged: (value) {
                  artistName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Country'),
                controller: TextEditingController(text: country),
                onChanged: (value) {
                  country = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Information'),
                controller: TextEditingController(text: information),
                onChanged: (value) {
                  information = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Artist Photo Name'),
                controller: TextEditingController(text: artistPhotoName),
                onChanged: (value) {
                  artistPhotoName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Artwork Name'),
                controller: TextEditingController(text: artworkName),
                onChanged: (value) {
                  artworkName = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (artistName.isNotEmpty &&
                  country.isNotEmpty &&
                  information.isNotEmpty &&
                  artistPhotoName.isNotEmpty &&
                  artworkName.isNotEmpty) {
                _updateArtist(context, artistSnapshot.id, artistName, country,
                    information, artistPhotoName, artworkName);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter all the details.'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _updateArtist(BuildContext context, String artistId, String artistName,
      String country, String information, String artistPhotoName,
      String artworkName) async {
    try {
      await FirebaseFirestore.instance.collection('artists').doc(artistId).update({
        'artistName': artistName,
        'country': country,
        'information': information,
        'artistPhotoName': artistPhotoName,
        'artworkName': artworkName,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Artist updated successfully.'),
        ),
      );
    } catch (e) {
      print('Error updating artist: $e');
    }
  }

  void _deleteArtist(BuildContext context, String artistId) async {
    try {
      await FirebaseFirestore.instance.collection('artists').doc(artistId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Artist deleted successfully.'),
        ),
      );
    } catch (e) {
      print('Error deleting artist: $e');
    }
  }
}
