import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Przekierowanie bezpośrednio do Dashboardu

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Tło - grafika z assets
          Image.asset(
            'assets/splash.png', // Użyj swojej grafiki
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6B46C1), Color(0xFF1E293B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            },
          ),
          // Nakładka z przyciskami i tekstem
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'SOUL MANAGER',
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 40,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Zostań swoim własnym Magiem',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.amber,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  side: BorderSide(color: Colors.amber, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
                child: Text(
                  'Rozpocznij Podróż',
                  style: TextStyle(fontSize: 22, color: Colors.amber),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Logika logowania - na razie przejście do DashboardScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
                child: Text(
                  'Zaloguj się',
                  style: TextStyle(fontSize: 18, color: Colors.amber),
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
