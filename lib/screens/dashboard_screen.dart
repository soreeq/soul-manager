import 'package:flutter/material.dart';
import '../main.dart'; // Dostęp do globalnego klucza ScaffoldMessenger
import '../user_state.dart'; // Dostęp do stanu użytkownika

class DashboardScreen extends StatefulWidget {
  final String nickname;
  final String birthDate;
  final String birthPlace;

  DashboardScreen({
    this.nickname = '',
    this.birthDate = '',
    this.birthPlace = '',
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  UserState userState = UserState();
  bool _taskCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Przykładowa funkcja generująca sentencję na dzień na podstawie ułożenia planet
  String getDailyReflection() {
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

  // Funkcja wyświetlająca efekt awansu na nowy poziom
  void _showLevelUpEffect(String title) {
    _animationController.forward(from: 0.0);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6B46C1), Color(0xFFD4AF37)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Gratulacje!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cinzel',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Awansowałeś na nowy poziom: $title!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD4AF37),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _animationController.reset();
                    },
                    child: Text('Kontynuuj',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard ${userState.title}',
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
                        widget.nickname.isNotEmpty
                            ? widget.nickname
                            : userState.title,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cinzel',
                        ),
                      ),
                      Text(
                        'Poziom ${userState.level}',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Pasek Energii Duchowej (Aura)
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
                    value: userState.aura / 100.0, // Wartość Aury jako procent
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade700,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Energia Duchowa: ${userState.aura}/100',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Pasek XP
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doświadczenie (XP)',
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: userState.expBar, // Wartość paska XP jako procent
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade700,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'XP: ${userState.xp}/${userState.level == 10 ? "MAX" : UserState.levelThresholds[userState.level]}',
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
                        'Medytacja w parku: +15 Energii Ziemi, +50 XP',
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
                          onPressed: _taskCompleted
                              ? null
                              : () {
                                  setState(() {
                                    _taskCompleted = true;
                                    bool levelUp = userState.completeTask(
                                        50, 15); // +50 XP, +15 Aury
                                    if (levelUp) {
                                      _showLevelUpEffect(userState.title);
                                    }
                                  });
                                  MyApp.scaffoldMessengerKey.currentState
                                      ?.removeCurrentSnackBar();
                                  MyApp.scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Zadanie wykonane! Otrzymano +15 Energii Ziemi i +50 XP'),
                                      backgroundColor: Color(0xFFD4AF37),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                },
                          child: Text(_taskCompleted ? 'Wykonano' : 'Wykonaj',
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
                  StatCard(
                      icon: Icons.star,
                      label: 'Punkty XP',
                      value: '${userState.xp}'),
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
