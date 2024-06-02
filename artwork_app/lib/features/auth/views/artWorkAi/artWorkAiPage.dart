import 'package:flutter/material.dart';

class ArtWorkAiPage extends StatefulWidget {
  const ArtWorkAiPage({Key? key}) : super(key: key);

  @override
  _ArtWorkAiPageState createState() => _ArtWorkAiPageState();
}

class _ArtWorkAiPageState extends State<ArtWorkAiPage> {
  // Örnek sorular ve cevapları
  final List<Map<String, String>> _questionsAndAnswers = [
    {
      'question': 'Can you provide general information about your application?',
      'answer': 'Of course, our ARTVISTA application is a platform that allows you to discover artworks.'
    },
    {
      'question': 'Which product categories do you offer?',
      'answer': 'In our ARTVISTA application, you can find products in categories such as painting, sculpture, ceramics, and many others.'
    },
    {
      'question': 'How can I get information about my orders?',
      'answer': 'You can track the status of your orders in the "My Orders" section.'
    },
    {
      'question': 'How can I sell my artworks?',
      'answer': 'You can apply to sell your artworks in the "Do You Want to Sell" section.'
    },
    {
      'question': 'I have another issue, what should I do?',
      'answer': 'If you have another issue, please contact us through the "Contact" section.'
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We accept various payment methods including credit/debit cards, PayPal, and bank transfers.'
    },
    {
      'question': 'Do you offer international shipping?',
      'answer': 'Yes, we offer international shipping to most countries. Shipping costs may vary depending on the destination.'
    },
    {
      'question': 'What is the return policy?',
      'answer': 'Our return policy allows you to return artworks within 30 days of purchase for a full refund. Please refer to our "Return Policy" section for more details.'
    },
    {
      'question': 'Can I cancel my order?',
      'answer': 'Yes, you can cancel your order within 24 hours of placing it. After that, please contact customer support for assistance.'
    },
    {
      'question': 'Do you have a mobile app?',
      'answer': 'Yes, we have a mobile app available for both iOS and Android devices. You can download it from the App Store or Google Play Store.'
    },
    {
      'question': 'How can I contact customer support?',
      'answer': 'You can contact customer support by sending an email to support@artvista.com or by calling our toll-free number at 1-800-123-4567.'
    },
  ];

  // Seçili soru ve cevap
  String? _selectedQuestion;
  String? _selectedAnswer;
  // ignore: unused_field
  String? _userQuestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArtWork AI'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/logo.jpeg'), // Logonun konumunu belirtin
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: const Text(
                    'Hello! Welcome to ArtWork AI. How can I assist you today?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _questionsAndAnswers.length,
                        itemBuilder: (context, index) {
                          final question = _questionsAndAnswers[index]['question']!;
                          final answer = _questionsAndAnswers[index]['answer']!;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedQuestion = question;
                                _selectedAnswer = answer;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: _selectedQuestion == question ? Colors.blue.shade100 : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                question,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedQuestion == question ? Colors.blue : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_selectedQuestion != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade100,
              child: Text(
                'AI: $_selectedAnswer',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      // Kullanıcının sorusunu al ve AI'nın cevabını bul
                      final foundQuestion = _questionsAndAnswers.firstWhere(
                          (qa) => qa['question'] == value,
                          orElse: () => {
                                'question': value,
                                'answer': 'Sorry, I couldn\'t find an answer to your question.'
                              });
                      setState(() {
                        _selectedQuestion = foundQuestion['question'];
                        _selectedAnswer = foundQuestion['answer'];
                        _userQuestion = value; // Kullanıcının sorusu kaydedildi
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blue, // Buton rengi
                shadowColor: Colors.blueAccent, // Buton gölgesi
                elevation: 5, // Gölge yüksekliği
              ),
              child: const Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/logo.jpeg'), // Logonun konumunu belirtin
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '123 Main Street, City, Country',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Email:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'info@example.com',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Phone:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '+123 456 7890',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Timestamp:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'May 4, 2024 at 6:52:42 AM UTC+3',
                        style: TextStyle(fontSize: 16),
                      ),
                
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
