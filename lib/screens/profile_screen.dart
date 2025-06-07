import 'package:flutter/material.dart';
import 'package:soul_manager/screens/cosmogram_analysis_screen.dart';
import 'package:soul_manager/screens/dashboard_screen.dart';
import 'package:soul_manager/screens/mood_scanner_screen.dart';
import 'package:soul_manager/screens/tasks_screen.dart';
import '../main.dart'; // Dostęp do globalnego klucza ScaffoldMessenger

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Maga',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 24),
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
                  child: Text(
                    'Twój kosmogram jest w trakcie analizy. Wkrótce dostępne będą szczegółowe dane astrologiczne.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF1E293B),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavIcon(
              icon: Icons.dashboard,
              label: 'Dashboard',
              active: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                      nickname: _nicknameController.text,
                      birthDate: _birthDateController.text,
                      birthPlace: _birthPlaceController.text,
                    ),
                  ),
                );
                MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text('Przejście do: Dashboard'),
                    backgroundColor: Color(0xFFD4AF37),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            NavIcon(
              icon: Icons.task_alt,
              label: 'Zadania',
              active: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TasksScreen()),
                );
                MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text('Przejście do: Zadania'),
                    backgroundColor: Color(0xFFD4AF37),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            NavIcon(
              icon: Icons.psychology,
              label: 'Skaner',
              active: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MoodScannerScreen()),
                );
                MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text('Przejście do: Skaner Potrzeb'),
                    backgroundColor: Color(0xFFD4AF37),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            NavIcon(
              icon: Icons.stars,
              label: 'Astrologia',
              active: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CosmogramAnalysisScreen()),
                );
                MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text('Przejście do: Analiza Kosmogramu'),
                    backgroundColor: Color(0xFFD4AF37),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            NavIcon(
              icon: Icons.person,
              label: 'Profil',
              active: true,
              onTap: () {
                // Już jesteśmy na Profilu, więc nie robimy nic
              },
            ),
          ],
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

class NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const NavIcon({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? Colors.amber : Colors.white70, size: 24),
          Text(label,
              style: TextStyle(
                  color: active ? Colors.amber : Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
