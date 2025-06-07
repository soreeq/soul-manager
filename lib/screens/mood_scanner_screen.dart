import 'package:flutter/material.dart';
import 'tasks_screen.dart'; // Import, aby móc przejść do ekranu zadań z propozycjami

class MoodScannerScreen extends StatefulWidget {
  @override
  _MoodScannerScreenState createState() => _MoodScannerScreenState();
}

class _MoodScannerScreenState extends State<MoodScannerScreen> {
  int _currentStep = 0;
  String _selectedMood = '';
  String _selectedNeed = '';
  bool _quizCompleted = false;
  List<Map<String, dynamic>> _recommendedTasks = [];

  // Lista emocji do wyboru
  final List<String> moods = [
    'Spokojny',
    'Zestresowany',
    'Zainspirowany',
    'Rozproszony',
    'Smutny',
    'Energiczny',
  ];
  // Lista potrzeb do wyboru
  final List<String> needs = [
    'Uziemienia',
    'Inspiracji',
    'Spokoju',
    'Jasności',
    'Wsparcia',
    'Równowagi',
  ];

  // Funkcja rekomendująca zadania na podstawie nastroju i potrzeb
  void _recommendTasks() {
    List<Map<String, dynamic>> tasks = [];
    if (_selectedMood.isNotEmpty && _selectedNeed.isNotEmpty) {
      if (_selectedMood == 'Zestresowany' || _selectedNeed == 'Spokoju') {
        tasks.add({
          'title': 'Medytacja przy Wodzie',
          'description': 'Medytuj przez 10 minut przy wodzie.',
          'reward': '+20 Spokoju, +5 XP',
        });
        tasks.add({
          'title': 'Kąpiel Oczyszczająca',
          'description': 'Weź kąpiel z solą, wizualizując oczyszczenie.',
          'reward': '+15 Odnowy, +3 XP',
        });
      }
      if (_selectedMood == 'Zainspirowany' || _selectedNeed == 'Inspiracji') {
        tasks.add({
          'title': 'Dziennik Kreatywny',
          'description': 'Zapisz 3 pomysły lub myśli bez oceniania.',
          'reward': '+15 Energii Ognia, +5 XP',
        });
        tasks.add({
          'title': 'Rysunek Intuicyjny',
          'description': 'Narysuj coś odzwierciedlającego Twój nastrój.',
          'reward': '+10 Inspiracji, +3 XP',
        });
      }
      if (_selectedMood == 'Rozproszony' || _selectedNeed == 'Jasności') {
        tasks.add({
          'title': 'Ćwiczenie Oddechowe',
          'description': 'Wykonaj 5-minutowe głębokie oddychanie.',
          'reward': '+15 Jasności Umysłu, +4 XP',
        });
        tasks.add({
          'title': 'Słuchanie Ciszy',
          'description': 'Spędź 5 minut w całkowitej ciszy.',
          'reward': '+12 Wglądu, +3 XP',
        });
      }
      if (_selectedMood == 'Smutny' || _selectedNeed == 'Wsparcia') {
        tasks.add({
          'title': 'Życzliwość dla Innych',
          'description': 'Wykonaj mały gest dobroci.',
          'reward': '+15 Energii Serca, +3 XP',
        });
        tasks.add({
          'title': 'Wdzięczność za Emocje',
          'description':
              'Zapisz 3 rzeczy związane z emocjami, za które jesteś wdzięczny.',
          'reward': '+10 Równowagi, +2 XP',
        });
      }
      if (_selectedNeed == 'Uziemienia') {
        tasks.add({
          'title': 'Spacer w Naturze',
          'description': 'Idź na 15-minutowy spacer do parku lub lasu.',
          'reward': '+20 Energii Ziemi, +5 XP',
        });
        tasks.add({
          'title': 'Ćwiczenie Boso',
          'description': 'Stań boso na trawie przez 5 minut.',
          'reward': '+15 Stabilności, +3 XP',
        });
      }
      if (_selectedMood == 'Energiczny' || _selectedNeed == 'Równowagi') {
        tasks.add({
          'title': 'Taniec Wyrażenia',
          'description': 'Tańcz przez 5 minut, wyrażając emocje.',
          'reward': '+12 Pasji, +4 XP',
        });
        tasks.add({
          'title': 'Wieczorna Refleksja',
          'description': 'Podsumuj dzień, zapisując 3 sukcesy.',
          'reward': '+20 Rozwoju Ducha, +5 XP',
        });
      }
    }
    setState(() {
      _recommendedTasks = tasks;
      _quizCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skaner Potrzeb',
          style: TextStyle(
            fontFamily: 'Cinzel',
            color: Colors.amber,
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF1E293B),
      body: _quizCompleted ? _buildResults(context) : _buildQuiz(context),
    );
  }

  Widget _buildQuiz(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _currentStep == 0
                        ? 'Jak się dziś czujesz?'
                        : 'Czego dziś potrzebujesz?',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...(_currentStep == 0 ? moods : needs).map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Card(
                      color:
                          (_currentStep == 0 ? _selectedMood : _selectedNeed) ==
                                  item
                              ? Color(0xFFD4AF37).withOpacity(0.3)
                              : Color(0xFF2C3E50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          item,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onTap: () {
                          setState(() {
                            if (_currentStep == 0) {
                              _selectedMood = item;
                            } else {
                              _selectedNeed = item;
                            }
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  child: Text('Wstecz', style: TextStyle(color: Colors.white)),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD4AF37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_currentStep == 0 && _selectedMood.isNotEmpty) {
                    setState(() {
                      _currentStep++;
                    });
                  } else if (_currentStep == 1 && _selectedNeed.isNotEmpty) {
                    _recommendTasks();
                  }
                },
                child: Text(
                  _currentStep == 0 ? 'Dalej' : 'Zakończ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Twoje Wyniki',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Nastrój: $_selectedMood\nPotrzeba: $_selectedNeed',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Rekomendowane Zadania',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recommendedTasks.length,
            itemBuilder: (context, index) {
              var task = _recommendedTasks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Card(
                  color: Color(0xFF2C3E50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['description'],
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Nagroda: ${task['reward']}',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD4AF37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Można dodać logikę rozpoczęcia zadania
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Rozpoczęto: ${task['title']}'),
                            backgroundColor: Color(0xFFD4AF37),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        'Zacznij',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {
                _quizCompleted = false;
                _currentStep = 0;
                _selectedMood = '';
                _selectedNeed = '';
                _recommendedTasks = [];
              });
            },
            child: Text('Ponów Skan', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
