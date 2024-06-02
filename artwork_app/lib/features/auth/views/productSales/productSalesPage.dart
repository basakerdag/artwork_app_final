import 'package:artwork_app/features/auth/views/productSales/card_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSalesPage extends StatefulWidget {
  ProductSalesPage({Key? key}) : super(key: key);

  @override
  _ProductSalesPageState createState() => _ProductSalesPageState();
}

class _ProductSalesPageState extends State<ProductSalesPage> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  late CollectionReference _shopCollection;

  @override
  void initState() {
    super.initState();
    _shopCollection = FirebaseFirestore.instance.collection('users').doc(userId).collection('shop');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _shopCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final product = Product(
                imageUrl: 'assets/images/${documents[index]['photoName']}',
                name: documents[index]['productName'],
                price: documents[index]['price'],
              );
              return ListTile(
                leading: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(product.imageUrl),
                ),
                title: Text(
                  product.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${product.price} \$',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _shopCollection.doc(documents[index].id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CardInfoPage()),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _shopCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Toplam: \$0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
              }

              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              double totalPrice = 0;
              for (var doc in documents) {
                totalPrice += doc['price'];
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Toplam: \$${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CardInfoPage()),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Product {
  final String imageUrl;
  final String name;
  final double price;

  Product({required this.imageUrl, required this.name, required this.price});
}
