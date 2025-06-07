import 'package:flutter/material.dart';
import 'package:soul_manager/screens/main_screen.dart' as screens;
import 'package:soul_manager/main.dart' as app;

class CosmogramAnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analiza Kosmogramu',
            style: TextStyle(fontFamily: 'Cinzel', color: Colors.amber)),
        backgroundColor: Color(0xFF1E293B),
      ),
      backgroundColor: Color(0xFF1E293B),
      body: Column(
        children: [
          // Filtry widoku
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterButton(
                    label: 'Pełny Kosmogram',
                    selected: true,
                    onPressed: () {
                      app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Wybrano: Pełny Kosmogram'),
                          backgroundColor: Color(0xFFD4AF37),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }),
                FilterButton(
                    label: 'Tranzyty Dnia',
                    selected: false,
                    onPressed: () {
                      app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Wybrano: Tranzyty Dnia'),
                          backgroundColor: Color(0xFFD4AF37),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }),
                FilterButton(
                    label: 'Progresje',
                    selected: false,
                    onPressed: () {
                      app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Wybrano: Progresje'),
                          backgroundColor: Color(0xFFD4AF37),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }),
              ],
            ),
          ),
          // Interaktywny wykres kosmogramu - placeholder
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 2),
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Color(0xFF6B46C1), Color(0xFF1E293B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Interaktywny Wykres Kosmogramu',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Dotknij, aby zobaczyć szczegóły planet i aspektów',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Dziennie aspekty
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xFF2C3E50),
              padding: EdgeInsets.all(8),
              child: ListView(
                children: [
                  AspectTile(
                    icon: Icons.brightness_3,
                    title: 'Księżyc-Jowisz',
                    description: 'Rozwój intuicji i optymizmu',
                  ),
                  AspectTile(
                    icon: Icons.favorite,
                    title: 'Wenus-Mars',
                    description: 'Napięcia w relacjach, kontroluj emocje',
                  ),
                  AspectTile(
                    icon: Icons.warning_amber,
                    title: 'Merkury Retrogradacja',
                    description: 'Unikaj ważnych decyzji',
                  ),
                ],
              ),
            ),
          ),
          // Panel interpretacji
          Expanded(
            flex: 2,
            child: Container(
              color: Color(0xFF34495E).withOpacity(0.8),
              padding: EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Szczegółowa Interpretacja:',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Słońce w Byku (2. Dom): Stabilność materialna i komfort są kluczowe w Twoim życiu. Skup się na budowaniu bezpieczeństwa.\n'
                      'Mars w opozycji do Wenus: Możliwe napięcia w relacjach dziś. Unikaj impulsywnych reakcji i szukaj kompromisu.\n'
                      'Saturn w Koziorożcu: Dyscyplina i odpowiedzialność przyniosą długoterminowe korzyści. Pracuj nad swoimi celami.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  const FilterButton(
      {required this.label, this.selected = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.amber : Colors.grey.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
            color: selected ? Colors.black : Colors.white, fontSize: 14),
      ),
    );
  }
}

class AspectTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AspectTile(
      {required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber, size: 20),
      title: Text(title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(description,
          style: TextStyle(color: Colors.white70, fontSize: 14)),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
    );
  }
}
