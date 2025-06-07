import 'package:flutter/material.dart';
import '../main.dart'; // Dostęp do globalnego klucza ScaffoldMessenger

class DashboardScreen extends StatelessWidget {
  final String nickname;
  final String birthDate;
  final String birthPlace;

  DashboardScreen({
    this.nickname = '',
    this.birthDate = '',
    this.birthPlace = '',
  });

  // Przykładowa funkcja generująca sentencję na dzień na podstawie ułożenia planet
  String getDailyReflection() {
    // Na razie statyczne dane, można później połączyć z API lub lokalną bazą danych astrologicznych
    DateTime today = DateTime.now();
    int dayOfWeek = today.weekday;
    List<String> reflections = [
      "Mars w Strzelcu: Działaj odważnie i podążaj za swoimi marzeniami.", // Poniedziałek
      "Księżyc w Raku: Skup się na introspekcji i dbaj o swoje emocje.", // Wtorek
      "Merkury w Bliźniętach: Wyrażaj swoje myśli z jasnością i ciekawością.", // Środa
      "Wenus w Wadze: Szukaj harmonii w relacjach i celebruj piękno.", // Czwartek
      "Jowisz w Rybach: Otwórz się na rozwój duchowy i nowe możliwości.", // Piątek
      "Saturn w Koziorożcu: Buduj swoje cele z cierpliwością i determinacją.", // Sobota
      "Słońce w Lwie: Świeć jasno i inspiruj innych swoją autentycznością.", // Niedziela
    ];
    return reflections[dayOfWeek - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Maga',
          style: TextStyle(
              fontFamily: 'Cinzel', color: Colors.amber, fontSize: 22),
        ),
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF1E293B),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sekcja Awatara i Poziomu
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6B46C1), Color(0xFF34495E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Awatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/avatar_placeholder.png'), // Placeholder dla awatara
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Informacje o użytkowniku
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nickname.isNotEmpty ? nickname : 'Mag Nowicjusz',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cinzel',
                        ),
                      ),
                      Text(
                        'Poziom 1',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Pasek Energii Duchowej
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aura Dnia',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.75, // Wartość przykładowa (75% energii)
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade700,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Energia Duchowa: 75/100',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Zadanie Dnia
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Color(0xFF2C3E50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zadanie Dnia',
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Medytacja w parku: +15 Energii Ziemi',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD4AF37),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            // Logika oznaczenia zadania jako wykonane
                            MyApp.scaffoldMessengerKey.currentState
                                ?.removeCurrentSnackBar();
                            MyApp.scaffoldMessengerKey.currentState
                                ?.showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Zadanie wykonane! Otrzymano +15 Energii Ziemi'),
                                backgroundColor: Color(0xFFD4AF37),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          },
                          child: Text('Wykonaj',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Szybkie Statystyki
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Szybkie Statystyki',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatCard(icon: Icons.star, label: 'Punkty XP', value: '150'),
                  StatCard(
                      icon: Icons.task_alt, label: 'Zadania', value: '3/5'),
                ],
              ),
            ),
            // Wskazówki Astrologiczne
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Color(0xFF2C3E50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wskazówka Astrologiczna',
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Księżyc w Skorpionie – dziś skup się na introspekcji.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Sekcja: Daily Reflection
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Color(0xFF2C3E50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Codzienna Refleksja',
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        getDailyReflection(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatCard(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF34495E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 24),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text(value,
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
