import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'tasks_screen.dart';
import 'mood_scanner_screen.dart';
import 'cosmogram_analysis_screen.dart';
import 'profile_screen.dart';
import '../main.dart'; // Dostęp do globalnego klucza ScaffoldMessenger
import '../user_state.dart'; // Dostęp do stanu użytkownika

class MainScreen extends StatefulWidget {
  final String nickname;
  final String birthDate;
  final String birthPlace;

  MainScreen({
    this.nickname = '',
    this.birthDate = '',
    this.birthPlace = '',
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;
  UserState userState = UserState(); // Globalny stan użytkownika

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(
        nickname: widget.nickname,
        birthDate: widget.birthDate,
        birthPlace: widget.birthPlace,
      ),
      TasksScreen(),
      MoodScannerScreen(),
      CosmogramAnalysisScreen(),
      ProfileScreen(
        nickname: widget.nickname,
        birthDate: widget.birthDate,
        birthPlace: widget.birthPlace,
      ),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    String screenName;
    switch (index) {
      case 0:
        screenName = 'Dashboard';
        break;
      case 1:
        screenName = 'Zadania';
        break;
      case 2:
        screenName = 'Skaner Potrzeb';
        break;
      case 3:
        screenName = 'Analiza Kosmogramu';
        break;
      case 4:
        screenName = 'Profil';
        break;
      default:
        screenName = 'Nieznany ekran';
    }
    // Czyszczenie poprzednich SnackBarów przed wyświetleniem nowego
    MyApp.scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Przejście do: $screenName'),
        backgroundColor: Color(0xFFD4AF37),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        color: Color(0xFF1E293B),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavIcon(
              icon: Icons.dashboard,
              label: 'Dashboard',
              active: _currentIndex == 0,
              onTap: () => _onTabTapped(0),
            ),
            NavIcon(
              icon: Icons.task_alt,
              label: 'Zadania',
              active: _currentIndex == 1,
              onTap: () => _onTabTapped(1),
            ),
            NavIcon(
              icon: Icons.psychology,
              label: 'Skaner',
              active: _currentIndex == 2,
              onTap: () => _onTabTapped(2),
            ),
            NavIcon(
              icon: Icons.stars,
              label: 'Astrologia',
              active: _currentIndex == 3,
              onTap: () => _onTabTapped(3),
            ),
            NavIcon(
              icon: Icons.person,
              label: 'Profil',
              active: _currentIndex == 4,
              onTap: () => _onTabTapped(4),
            ),
          ],
        ),
      ),
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
