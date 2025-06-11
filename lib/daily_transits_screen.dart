// Plik: screens/daily_transits_screen.dart
import 'package:flutter/material.dart';

class DailyTransitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tranzyty Dnia',
            style: TextStyle(fontFamily: 'Cinzel', color: Colors.amber)),
        backgroundColor: Color(0xFF1E293B),
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Color(0xFF1E293B),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dzisiejsze Tranzyty Planetarne',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildTransitInfo('Koniunkcja Księżyca i Jowisza',
                'Sprzyja rozwojowi duchowemu, optymizmowi i hojności. Dobry czas na naukę i podróże mentalne.'),
            SizedBox(height: 12),
            _buildTransitInfo('Słońce w kwadraturze do Saturna',
                'Może przynieść poczucie ograniczenia i frustracji. Ważna jest cierpliwość i systematyczna praca nad celami.'),
            SizedBox(height: 12),
            _buildTransitInfo('Pełnia Księżyca (za 3 dni)',
                'Energia osiąga swój szczyt. Czas na podsumowania, uwalnianie tego, co już nie służy i manifestację intencji.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitInfo(String title, String description) {
    return Card(
      color: Color(0xFF2C3E50),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(description,
                style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
