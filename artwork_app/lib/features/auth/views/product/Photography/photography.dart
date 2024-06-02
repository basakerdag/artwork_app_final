import 'package:artwork_app/features/auth/views/product/productDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Photography extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photography', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 255, 253, 253),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'), // Arka plan resminizin yolu
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
          ),
          FutureBuilder(
            future: _getUserUid(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return _buildProductList(snapshot.data.toString());
              }
            },
          ),
        ],
      ),
      floatingActionButton: FutureBuilder(
        future: _getUserUid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            String userUid = snapshot.data.toString();
            if (userUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1') {
              return FloatingActionButton(
                onPressed: () {
                  _addNewProduct(context);
                },
                child: const Icon(Icons.add),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              );
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }

  Widget _buildProductList(String userUid) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('photographyProduct').orderBy('productName').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Map<String, dynamic>> products = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> productData = products[index];

            final String productId = snapshot.data!.docs[index].id;
            final String productName = productData['productName'] ?? '';
            final String productArtist = productData['productArtist'] ?? '';
            final String productDescription = productData['productDescription'] ?? '';
            final String qrCodeUrl = productData['qrCodeUrl'] ?? '';
            final String imageName = productData['imageName'] ?? '';
            final double imageWidth = productData['imageWidth'] ?? 150.0;
            final double imageHeight = productData['imageHeight'] ?? 150.0;
            final double price = productData['price'] ?? 0.0;

            return _buildProductCard(
              context,
              productId,
              productName,
              productArtist,
              productDescription,
              qrCodeUrl,
              imageName,
              imageWidth,
              imageHeight,
              price,
              isAdminButtonVisible: userUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1',
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    String productId,
    String productName,
    String productArtist,
    String productDescription,
    String qrCodeUrl,
    String imageName,
    double imageWidth,
    double imageHeight,
    double price, {
    required bool isAdminButtonVisible,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Image.asset(
          'assets/images/$imageName',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          productName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Artist: $productArtist',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              'Price: \$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                productName: productName,
                productArtist: productArtist,
                productDescription: productDescription,
                qrCodeUrl: qrCodeUrl,
                imageName: imageName,
                imageWidth: imageWidth,
                imageHeight: imageHeight,
                price: price,
                sendNotification: () {},
              ),
            ),
          );
        },
        trailing: isAdminButtonVisible
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Product'),
                          content: const Text('Are you sure you want to delete the product?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteProduct(productId);
                                Navigator.pop(context);
                              },
                              child: const Text('OK', style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editProduct(
                        context,
                        productId,
                        productName,
                        productArtist,
                        productDescription,
                        qrCodeUrl,
                        imageName,
                        imageWidth,
                        imageHeight,
                        price,
                      );
                    },
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Future<String> _getUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void _addNewProduct(BuildContext context) async {
    String productName = '';
    String productArtist = '';
    String productDescription = '';
    String qrCodeUrl = '';
    String imageName = '';
    double imageWidth = 150.0;
    double imageHeight = 150.0;
    double price = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Product', style: TextStyle(color: Colors.black)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                onChanged: (value) {
                  productName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Product Artist'),
                onChanged: (value) {
                  productArtist = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Product Description'),
                onChanged: (value) {
                  productDescription = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'QR Code URL'),
                onChanged: (value) {
                  qrCodeUrl = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Image Name'),
                onChanged: (value) {
                  imageName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Image Width'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  imageWidth = double.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Image Height'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  imageHeight = double.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  price = double.parse(value);
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
              if (productName.isNotEmpty &&
                  productArtist.isNotEmpty &&
                  productDescription.isNotEmpty &&
                  qrCodeUrl.isNotEmpty &&
                  imageName.isNotEmpty &&
                  imageWidth > 0 &&
                  imageHeight > 0 &&
                  price > 0) {
                _uploadProductToFirestore(
                  productName,
                  productArtist,
                  productDescription,
                  qrCodeUrl,
                  imageName,
                  imageWidth,
                  imageHeight,
                  price,
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter all product details.'),
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

  void _editProduct(
    BuildContext context,
    String productId,
    String productName,
    String productArtist,
    String productDescription,
    String qrCodeUrl,
    String imageName,
    double imageWidth,
    double imageHeight,
    double price,
  ) async {
    String editedProductName = productName;
    String editedProductArtist = productArtist;
    String editedProductDescription = productDescription;
    String editedQrCodeUrl = qrCodeUrl;
    String editedImageName = imageName;
    double editedImageWidth = imageWidth;
    double editedImageHeight = imageHeight;
    double editedPrice = price;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product', style: TextStyle(color: Colors.black)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                controller: TextEditingController(text: productName),
                onChanged: (value) {
                  editedProductName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Product Artist'),
                controller: TextEditingController(text: productArtist),
                onChanged: (value) {
                  editedProductArtist = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Product Description'),
                controller: TextEditingController(text: productDescription),
                onChanged: (value) {
                  editedProductDescription = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'QR Code URL'),
                controller: TextEditingController(text: qrCodeUrl),
                onChanged: (value) {
                  editedQrCodeUrl = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Image Name'),
                controller: TextEditingController(text: imageName),
                onChanged: (value) {
                  editedImageName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Image Width'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: imageWidth.toString()),
                onChanged: (value) {
                  editedImageWidth = double.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Image Height'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: imageHeight.toString()),
                onChanged: (value) {
                  editedImageHeight = double.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: TextEditingController(text: price.toString()),
                onChanged: (value) {
                  editedPrice = double.parse(value);
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
              if (editedProductName.isNotEmpty &&
                  editedProductArtist.isNotEmpty &&
                  editedProductDescription.isNotEmpty &&
                  editedQrCodeUrl.isNotEmpty &&
                  editedImageName.isNotEmpty &&
                  editedImageWidth > 0 &&
                  editedImageHeight > 0 &&
                  editedPrice > 0) {
                _updateProduct(
                  productId,
                  editedProductName,
                  editedProductArtist,
                  editedProductDescription,
                  editedQrCodeUrl,
                  editedImageName,
                  editedImageWidth,
                  editedImageHeight,
                  editedPrice,
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter all product details.'),
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

  void _uploadProductToFirestore(
    String productName,
    String productArtist,
    String productDescription,
    String qrCodeUrl,
    String imageName,
    double imageWidth,
    double imageHeight,
    double price,
  ) async {
    await FirebaseFirestore.instance.collection('photographyProduct').add({
      'productName': productName,
      'productArtist': productArtist,
      'productDescription': productDescription,
      'qrCodeUrl': qrCodeUrl,
      'imageName': imageName,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'price': price,
    }).then((value) {
      print('Product added to Firestore with ID: ${value.id}');
    }).catchError((error) {
      print('Error adding product to Firestore: $error');
    });
  }

  void _updateProduct(
    String productId,
    String editedProductName,
    String editedProductArtist,
    String editedProductDescription,
    String editedQrCodeUrl,
    String editedImageName,
    double editedImageWidth,
    double editedImageHeight,
    double editedPrice,
  ) {
    FirebaseFirestore.instance.collection('photographyProduct').doc(productId).update({
      'productName': editedProductName,
      'productArtist': editedProductArtist,
      'productDescription': editedProductDescription,
      'qrCodeUrl': editedQrCodeUrl,
      'imageName': editedImageName,
      'imageWidth': editedImageWidth,
      'imageHeight': editedImageHeight,
      'price': editedPrice,
    }).then((value) {
      print('Product updated in Firestore with ID: $productId');
    }).catchError((error) {
      print('Error updating product in Firestore: $error');
    });
  }

  void _deleteProduct(String productId) {
    FirebaseFirestore.instance.collection('photographyProduct').doc(productId).delete().then((value) {
      print('Product deleted from Firestore with ID: $productId');
    }).catchError((error) {
      print('Error deleting product from Firestore: $error');
    });
  }
}
