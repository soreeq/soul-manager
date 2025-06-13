import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soul_manager/screens/start_screen.dart';
import 'package:soul_manager/main.dart' as app;
import 'dashboard_screen.dart'; // Dostęp do ReflectionJournal

class ProfileScreen extends StatefulWidget {
  final String nickname;
  final String birthDate;
  final String birthPlace;

  ProfileScreen({
    required this.nickname,
    required this.birthDate,
    required this.birthPlace,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nicknameController;
  late TextEditingController _birthDateController;
  late TextEditingController _birthPlaceController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.nickname);
    _birthDateController = TextEditingController(text: widget.birthDate);
    _birthPlaceController = TextEditingController(text: widget.birthPlace);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  // Funkcja wylogowania
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartScreen()),
        (route) => false, // Usuń wszystkie poprzednie ekrany ze stosu
      );

      app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Zostałeś wylogowany'),
          backgroundColor: Color(0xFFD4AF37),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Błąd podczas wylogowywania: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Funkcja określania znaku zodiaku
  String getZodiacSign(String birthDate) {
    try {
      DateTime date = DateTime.parse(birthDate);
      int month = date.month;
      int day = date.day;

      if ((month == 3 && day >= 21) || (month == 4 && day <= 19))
        return 'Baran';
      if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Byk';
      if ((month == 5 && day >= 21) || (month == 6 && day <= 20))
        return 'Bliźnięta';
      if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Rak';
      if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Lew';
      if ((month == 8 && day >= 23) || (month == 9 && day <= 22))
        return 'Panna';
      if ((month == 9 && day >= 23) || (month == 10 && day <= 22))
        return 'Waga';
      if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
        return 'Skorpion';
      if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
        return 'Strzelec';
      if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
        return 'Koziorożec';
      if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
        return 'Wodnik';
      if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return 'Ryby';
    } catch (e) {
      return 'Nieznany';
    }
    return 'Nieznany';
  }

  // Funkcja zwracająca emoji znaku zodiaku
  String getZodiacEmoji(String sign) {
    switch (sign) {
      case 'Baran':
        return '♈';
      case 'Byk':
        return '♉';
      case 'Bliźnięta':
        return '♊';
      case 'Rak':
        return '♋';
      case 'Lew':
        return '♌';
      case 'Panna':
        return '♍';
      case 'Waga':
        return '♎';
      case 'Skorpion':
        return '♏';
      case 'Strzelec':
        return '♐';
      case 'Koziorożec':
        return '♑';
      case 'Wodnik':
        return '♒';
      case 'Ryby':
        return '♓';
      default:
        return '🌟';
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
    });
    app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Zmiany zapisane!'),
        backgroundColor: Color(0xFFD4AF37),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteReflection(int index) {
    setState(() {
      ReflectionJournal.entries.removeAt(index);
    });
    app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Wpis usunięty'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String zodiacSign = getZodiacSign(widget.birthDate);
    String zodiacEmoji = getZodiacEmoji(zodiacSign);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Adepta',
          style: TextStyle(
              fontFamily: 'Cinzel', color: Colors.amber, fontSize: 22),
        ),
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon:
                Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.amber),
            onPressed: _isEditing ? _saveChanges : _toggleEditing,
          ),
          // Przycisk wylogowania
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color(0xFF2C3E50),
                    title: Text('Wylogowanie',
                        style: TextStyle(color: Colors.amber)),
                    content: Text('Czy na pewno chcesz się wylogować?',
                        style: TextStyle(color: Colors.white)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Anuluj',
                            style: TextStyle(color: Colors.white70)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _logout();
                        },
                        child: Text('Wyloguj',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Wyloguj się',
          ),
        ],
      ),
      backgroundColor: Color(0xFF1E293B),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dane Kosmogramu z znakiem zodiaku
              Text(
                'Dane Kosmogramu',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Sekcja ze znakiem zodiaku
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF2C3E50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.amber.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  children: [
                    Text(
                      zodiacEmoji,
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Znak Zodiaku',
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          zodiacSign,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              _buildProfileField(
                label: 'Nickname',
                controller: _nicknameController,
                enabled: _isEditing,
              ),
              SizedBox(height: 16),
              _buildProfileField(
                label: 'Data urodzenia',
                controller: _birthDateController,
                enabled: _isEditing,
              ),
              SizedBox(height: 16),
              _buildProfileField(
                label: 'Miejsce urodzenia',
                controller: _birthPlaceController,
                enabled: _isEditing,
              ),
              SizedBox(height: 32),

              // Dziennik Refleksji
              Text(
                'Dziennik Refleksji',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Lista wpisów w dzienniku
              Container(
                constraints: BoxConstraints(maxHeight: 400),
                child: ReflectionJournal.entries.isEmpty
                    ? Card(
                        color: Color(0xFF2C3E50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Brak wpisów w dzienniku. Dodaj swoją pierwszą refleksję lub wdzięczność na ekranie głównym!',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: ReflectionJournal.entries.length,
                        itemBuilder: (context, index) {
                          final entry = ReflectionJournal.entries[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: entry.color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: entry.type == 'reflection'
                                    ? Colors.blue.withOpacity(0.5)
                                    : Colors.green.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        entry.type == 'reflection'
                                            ? Icons.lightbulb_outline
                                            : Icons.favorite_outline,
                                        color: entry.type == 'reflection'
                                            ? Colors.blue.shade700
                                            : Colors.green.shade700,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        entry.type == 'reflection'
                                            ? 'Refleksja'
                                            : 'Wdzięczność',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: entry.type == 'reflection'
                                              ? Colors.blue.shade700
                                              : Colors.green.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            color: Colors.red.shade400,
                                            size: 18),
                                        onPressed: () =>
                                            _deleteReflection(index),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    entry.text,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${entry.date.day.toString().padLeft(2, '0')}.${entry.date.month.toString().padLeft(2, '0')}.${entry.date.year}, ${entry.date.hour.toString().padLeft(2, '0')}:${entry.date.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              SizedBox(height: 32),

              // Podsumowanie Kosmogramu
              Text(
                'Podsumowanie Kosmogramu',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                color: Color(0xFF2C3E50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome,
                              color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Analiza Astrologiczna',
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Twój kosmogram jest w trakcie analizy. Wkrótce dostępne będą szczegółowe dane astrologiczne oparte na Twoich danych urodzeniowych.',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 14, height: 1.4),
                      ),
                      SizedBox(height: 16),

                      // Podstawowe informacje astrologiczne
                      if (widget.birthDate.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF34495E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Podstawowe dane:',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Data urodzenia: ${widget.birthDate}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                              if (widget.birthPlace.isNotEmpty)
                                Text(
                                  'Miejsce urodzenia: ${widget.birthPlace}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Znak zodiaku: ',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                  Text(
                                    zodiacEmoji,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    zodiacSign,
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Statystyki profilu
              Text(
                'Statystyki Adepta',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                color: Color(0xFF2C3E50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Wpisy w dzienniku:',
                              style: TextStyle(color: Colors.white70)),
                          Text('${ReflectionJournal.entries.length}',
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Refleksje:',
                              style: TextStyle(color: Colors.white70)),
                          Text(
                            '${ReflectionJournal.entries.where((e) => e.type == 'reflection').length}',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Wdzięczności:',
                              style: TextStyle(color: Colors.white70)),
                          Text(
                            '${ReflectionJournal.entries.where((e) => e.type == 'gratitude').length}',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Color(0xFF2C3E50),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
