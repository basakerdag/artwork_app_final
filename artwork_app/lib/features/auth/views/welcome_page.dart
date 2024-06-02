import 'dart:ui';
import 'package:artwork_app/features/auth/views/sign_in.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Arka plan resmi ve bulanıklık efekti
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/welcome.jpeg'), // Arka plan fotoğrafının yolunu belirtin
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Koyu bir üst katman
                    BlendMode.darken,
                  ),
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Bulanıklık efekti
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Hafif siyah bir katman
                ),
              ),
            ),
          ),
          // Logo çerçevesi
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1, // Yükseklik 1/10'unda
            child: Container(
              width: 150, // Çerçeve genişliği
              height: 150, // Çerçeve yüksekliği
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Daire şeklinde çerçeve
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 4), // Kenar rengi ve kalınlığı
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3), // Gölge konumu
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpeg', // Uygulama logosunun yolunu belirtin
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // "WELCOME TO ARTVISTA" metni
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35, // Yükseklik 1/3.5'inde
            child: const Text(
              "WELCOME TO ARTVISTA",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, // Yazı rengini beyaz olarak değiştirin
                fontSize: 36, // Yazı boyutunu artırın
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, // Eğik biçimde yazı ekleyin
                shadows: [
                  Shadow(
                    offset: Offset(0, 3),
                    blurRadius: 5,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
          // "Continue" butonu
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2, // Yüksekliğin 1/5'inde
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 1, end: 1.1), // Boyut animasyonu için başlangıç ve bitiş değerleri
              duration: const Duration(milliseconds: 300), // Animasyon süresi
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(), // SignIn sayfasına yönlendirme
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Buton içeriğine dolgular ekleyin
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Buton metin boyutunu artırın ve kalın yapın
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Buton metin rengi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Butonun kenar yuvarlaklığını artırın
                  ),
                  elevation: 10, // Butona belirgin bir gölge ekleyin
                  padding: const EdgeInsets.all(0), // Padding'i sıfırlayın
                  animationDuration: const Duration(milliseconds: 300), // Buton animasyon süresi
                ).copyWith(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
