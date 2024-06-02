import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:artwork_app/features/auth/views/product/productDetailPage.dart';

class YourFavoriteProductsPage extends StatefulWidget {
  @override
  _YourFavoriteProductsPageState createState() => _YourFavoriteProductsPageState();
}

class _YourFavoriteProductsPageState extends State<YourFavoriteProductsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchFavoriteProducts() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      QuerySnapshot querySnapshot = await _firestore.collection('users').doc(userId).collection('fav').get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['docId'] = doc.id;  // doc.id'yi veriye ekliyoruz
          return data;
        }).toList();
      }
    }
    return [];
  }

  Future<void> _removeFromFavorites(String docId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await _firestore.collection('users').doc(userId).collection('fav').doc(docId).delete();
    }
  }

  void _confirmRemoveFromFavorites(BuildContext context, String docId, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove from Favorites'),
          content: Text('"Do you want to remove the product from your favorites?"'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _removeFromFavorites(docId);
                onConfirm();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"The product has been removed from your favorites."'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _viewProductDetail(BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productName: product['productName'],
          productArtist: product['productArtist'],
          productDescription: product['productDescription'],
          qrCodeUrl: product['qrCodeUrl'],
          imageName: product['imageName'],
          imageWidth: product['imageWidth'],
          imageHeight: product['imageHeight'],
          price: product['price'],
          sendNotification: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('"Notification"'),
                  content: Text('"The product page has been opened."!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(), // Diyalogu kapat
                      child: Text('Okey'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorite Products'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchFavoriteProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('"An error has occurred."'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('"You have no favorite items."'));
          } else {
            List<Map<String, dynamic>> favoriteProducts = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> product = favoriteProducts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/${product['photoName']}'),
                    ),
                    title: Text(
                      product['productName'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${product['price'].toString()} \$',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmRemoveFromFavorites(context, product['docId'], () {
                          setState(() {
                            favoriteProducts.removeAt(index);
                          });
                        });
                      },
                    ),
                    onTap: () {
                      _viewProductDetail(context, product);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
