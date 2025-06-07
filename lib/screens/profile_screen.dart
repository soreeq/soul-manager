import 'package:flutter/material.dart';
import 'package:soul_manager/screens/main_screen.dart' as screens;
import 'package:soul_manager/main.dart' as app;

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
    app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
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
