import 'package:artwork_app/features/auth/views/artWorkAi/artWorkAiPage.dart';
import 'package:artwork_app/features/auth/views/favorite/yourFavoriteProductsPage.dart';
import 'package:artwork_app/features/auth/views/product/productPage.dart';
import 'package:flutter/material.dart';
import 'package:artwork_app/features/auth/views/aboutUs/aboutUsPage.dart';
import 'package:artwork_app/features/auth/views/artists/artistsPage.dart';
import 'package:artwork_app/features/auth/views/contact/contactPage.dart';
import 'package:artwork_app/features/auth/views/doYouWant/doYouWantPage.dart';
import 'package:artwork_app/features/auth/views/sign_in.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ARTVISTA',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, // Beyaz arkaplan
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.9), // Beyaz ve daha az opak arkaplan
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle('Welcome to ARTVISTA', context),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildListItem(context, 'Product Categories', Icons.category, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductPage()),
                      );
                    }),
                    _buildListItem(context, 'Artists', Icons.person, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ArtistsPage()),
                      );
                    }),
                    _buildListItem(context, 'ArtWork AI', Icons.computer, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ArtWorkAiPage()),
                      );
                    }),
                    _buildListItem(context, 'Do you want to sell your works of art?', Icons.monetization_on, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DoYouWantPage()),
                      );
                    }),
                    _buildListItem(context, 'Your Favorite Products', Icons.favorite, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  YourFavoriteProductsPage()),
                      );
                    }),

                    _buildListItem(context, 'About us', Icons.info, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUsPage()),
                      );
                    }),
                    _buildListItem(context, 'Contact', Icons.contact_mail, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContactPage()),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
            (route) => false,
          );
        },
        child: const Icon(Icons.exit_to_app),
        backgroundColor: Colors.pinkAccent, // Pembe arkaplan
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, // Sağ alt köşeye yerleştirme
    );
  }

  Widget _buildTitle(String title, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Beyaz ve daha az opak arkaplan
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductPage()),
              );
            },
            child: const Text(
              'Explore Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent, // Pembe arkaplan
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.pinkAccent.withOpacity(0.5),
              elevation: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.pink, // Pembe renkli ikon
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



