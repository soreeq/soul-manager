import 'package:flutter/material.dart';
import '../main.dart'; // Dostęp do globalnego klucza ScaffoldMessenger

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // Lista kategorii zadań z przykładowymi zadaniami
  final Map<String, List<Map<String, dynamic>>> taskCategories = {
    'Uziemienie (Energia Ziemi)': [
      {
        'title': 'Spacer w Naturze',
        'description': 'Idź na 15-minutowy spacer do parku lub lasu.',
        'reward': '+20 Energii Ziemi, +5 XP',
        'completed': false
      },
      {
        'title': 'Ćwiczenie Boso',
        'description': 'Stań boso na trawie przez 5 minut.',
        'reward': '+15 Stabilności, +3 XP',
        'completed': false
      },
      {
        'title': 'Dbanie o Rośliny',
        'description': 'Podlej rośliny w domu lub ogrodzie.',
        'reward': '+10 Harmonii, +2 XP',
        'completed': false
      },
    ],
    'Inspiracja (Energia Ognia)': [
      {
        'title': 'Dziennik Kreatywny',
        'description': 'Zapisz 3 pomysły lub myśli bez oceniania.',
        'reward': '+15 Energii Ognia, +5 XP',
        'completed': false
      },
      {
        'title': 'Rysunek Intuicyjny',
        'description': 'Narysuj coś odzwierciedlającego Twój nastrój.',
        'reward': '+10 Inspiracji, +3 XP',
        'completed': false
      },
      {
        'title': 'Taniec Wyrażenia',
        'description': 'Tańcz przez 5 minut, wyrażając emocje.',
        'reward': '+12 Pasji, +4 XP',
        'completed': false
      },
    ],
    'Spokój (Energia Wody)': [
      {
        'title': 'Medytacja przy Wodzie',
        'description': 'Medytuj przez 10 minut przy wodzie.',
        'reward': '+20 Spokoju, +5 XP',
        'completed': false
      },
      {
        'title': 'Kąpiel Oczyszczająca',
        'description': 'Weź kąpiel z solą, wizualizując oczyszczenie.',
        'reward': '+15 Odnowy, +3 XP',
        'completed': false
      },
      {
        'title': 'Wdzięczność za Emocje',
        'description':
            'Zapisz 3 rzeczy związane z emocjami, za które jesteś wdzięczny.',
        'reward': '+10 Równowagi, +2 XP',
        'completed': false
      },
    ],
    'Intuicja (Energia Powietrza)': [
      {
        'title': 'Ćwiczenie Oddechowe',
        'description': 'Wykonaj 5-minutowe głębokie oddychanie.',
        'reward': '+15 Jasności Umysłu, +4 XP',
        'completed': false
      },
      {
        'title': 'Tarot lub Runy',
        'description': 'Wyciągnij kartę tarota i zapisz przesłanie.',
        'reward': '+10 Intuicji, +3 XP',
        'completed': false
      },
      {
        'title': 'Słuchanie Ciszy',
        'description': 'Spędź 5 minut w całkowitej ciszy.',
        'reward': '+12 Wglądu, +3 XP',
        'completed': false
      },
    ],
    'Codzienna Refleksja (Energia Ducha)': [
      {
        'title': 'Rachunek Sumienia (Rano)',
        'description': 'Zastanów się, co chcesz poprawić dziś.',
        'reward': '+10 Świadomości, +2 XP',
        'completed': false
      },
      {
        'title': 'Podsumowanie Południa',
        'description': 'Przeanalizuj, jak trzymasz się postanowień.',
        'reward': '+15 Wglądu, +3 XP',
        'completed': false
      },
      {
        'title': 'Wieczorna Refleksja',
        'description':
            'Podsumuj dzień, zapisując 3 sukcesy i 1 rzecz do poprawy.',
        'reward': '+20 Rozwoju Ducha, +5 XP',
        'completed': false
      },
    ],
    'Zadania Astrologiczne (Energia Kosmosu)': [
      {
        'title': 'Działanie Zgodne z Tranzytem',
        'description': 'Skup się na emocjach (Księżyc w Skorpionie).',
        'reward': '+15 Energii Kosmicznej, +4 XP',
        'completed': false
      },
      {
        'title': 'Unikanie Konfliktów',
        'description': 'Unikaj sporów przy napięciu (Mars-Wenus).',
        'reward': '+10 Harmonii, +2 XP',
        'completed': false
      },
      {
        'title': 'Wykorzystanie Energii',
        'description': 'Zacznij projekt (Słońce-Jowisz).',
        'reward': '+20 Optymizmu, +5 XP',
        'completed': false
      },
    ],
    'Zadania Społeczne (Energia Wspólnoty)': [
      {
        'title': 'Życzliwość dla Innych',
        'description': 'Wykonaj mały gest dobroci.',
        'reward': '+15 Energii Serca, +3 XP',
        'completed': false
      },
      {
        'title': 'Dzielenie się Refleksją',
        'description': 'Podziel się myślą z kimś bliskim.',
        'reward': '+10 Połączenia, +2 XP',
        'completed': false
      },
      {
        'title': 'Wspólna Medytacja',
        'description': 'Zaproś kogoś do wspólnej medytacji.',
        'reward': '+20 Energii Wspólnoty, +5 XP',
        'completed': false
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Zadania Spirytualne',
          style: TextStyle(
              fontFamily: 'Cinzel', color: Colors.amber, fontSize: 22),
        ),
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF1E293B),
      body: ListView.builder(
        itemCount: taskCategories.keys.length,
        itemBuilder: (context, index) {
          String category = taskCategories.keys.elementAt(index);
          List<Map<String, dynamic>> tasks = taskCategories[category]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  category,
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ...tasks
                  .map((task) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          color: Color(0xFF2C3E50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(
                              task['title'],
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['description'],
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Nagroda: ${task['reward']}',
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: task['completed']
                                ? Icon(Icons.check_circle,
                                    color: Colors.greenAccent)
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFD4AF37),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        task['completed'] = !task['completed'];
                                      });
                                      MyApp.scaffoldMessengerKey.currentState
                                          ?.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${task['title']} wykonane! Otrzymano ${task['reward']}'),
                                          backgroundColor: Color(0xFFD4AF37),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Text('Wykonaj',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          );
        },
      ),
    );
  }
}
