import 'package:flutter/material.dart';
import 'package:soul_manager/screens/start_screen.dart';
import 'package:soul_manager/user_state.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/mood_scanner_screen.dart';
import 'screens/cosmogram_analysis_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Globalny klucz dla ScaffoldMessenger
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserState()..initializeUser(),
        child: MaterialApp(
          title: 'Soul Manager',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          scaffoldMessengerKey:
              scaffoldMessengerKey, // Globalny klucz dla SnackBarów
          home: StartScreen(),
          routes: {
            '/astrology/daily_transits': (context) => DailyTransitsScreen(),
          },
          onGenerateRoute: (settings) {
            // Możesz dodać bardziej złożoną logikę tras, jeśli będzie potrzebna
            return null;
          },
        ));
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(),
    TasksScreen(),
    MoodScannerScreen(),
    CosmogramAnalysisScreen(),
  ];

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
      default:
        screenName = 'Nieznany ekran';
    }
    ScaffoldMessenger.of(context).showSnackBar(
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
              active: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profil - wkrótce dostępny'),
                    backgroundColor: Color(0xFFD4AF37),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
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
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.amber : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
