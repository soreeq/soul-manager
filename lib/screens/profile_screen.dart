import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart'; // Dostęp do globalnego klucza ScaffoldMessenger
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

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
    });
    MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
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
    MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Wpis usunięty'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      backgroundColor: Color(0xFF1E293B),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dane Kosmogramu
              Text(
                'Dane Kosmogramu',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
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
                                    DateFormat('dd.MM.yyyy, HH:mm')
                                        .format(entry.date),
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

                      // Podstawowe informacje astrologiczne (placeholder)
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
                              Text(
                                'Znak zodiaku: Będzie obliczony na podstawie daty urodzenia',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
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
