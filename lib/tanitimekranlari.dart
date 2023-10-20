import 'package:flutter/material.dart';
import 'package:kilitsistemi/kilitsistemipage.dart';
import 'package:lottie/lottie.dart';

class tanitimpage extends StatefulWidget {
  @override
  _tanitimpageState createState() => _tanitimpageState();
}

class _tanitimpageState extends State<tanitimpage> {
  int _currentPage = 0;

  List<Widget> _pages = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/1.tanitim.json'),
        SizedBox(height: 20.0),
        Text(
          'Parmak iziniz ile kilitleri açabilirsiniz! Tek bir dokunuşla\nen yüksek güvenliği deneyimleyin.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/2.tanitim.json'),
        SizedBox(height: 20.0),
        Text(
          'Güvenlik her şeyden önemlidir. Uygulamamızla endişesiz ve huzurlu bir şekilde yaşayın.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage == 1)
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentPage = 0;
                  });
                },
                child: Text('Geri'),
              ),
            if (_currentPage == 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentPage = 1;
                  });
                },
                child: Text('İleri'),
              ),
            if (_currentPage == 1)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KilitKontrolPage()),
                  );
                },
                child: Text('Tamam'),
              ),
          ],
        ),
      ),
    );
  }
}
