import 'package:flutter/material.dart';
import 'package:soul_manager/screens/profile_creation_screen.dart';
import 'package:soul_manager/screens/main_screen.dart' as screens;
import 'package:soul_manager/main.dart' as app;

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _textAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _buttonAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              FadeTransition(
                opacity: _textAnimation,
                child: Column(
                  children: [
                    Text(
                      'SOUL',
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 50,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.amber.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'MANAGER',
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 50,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.amber.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  'Odkryj moc w swoim wnętrzu',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ScaleTransition(
                scale: _buttonAnimation,
                child: ElevatedButton(
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
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            screens.MainScreen(
                          nickname: '',
                          birthDate: '',
                          birthPlace: '',
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    );
                    app.MyApp.scaffoldMessengerKey.currentState
                        ?.removeCurrentSnackBar();
                    app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                      SnackBar(
                        content: Text(
                            'Witaj w Soul Manager! Rozpocznij swoją podróż.'),
                        backgroundColor: Color(0xFFD4AF37),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  child: Text(
                    'Rozpocznij Podróż',
                    style: TextStyle(fontSize: 22, color: Colors.amber),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ProfileCreationScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                    ),
                  );
                  app.MyApp.scaffoldMessengerKey.currentState
                      ?.removeCurrentSnackBar();
                  app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                      content: Text('Rozpocznij tworzenie profilu!'),
                      backgroundColor: Color(0xFFD4AF37),
                      duration: Duration(seconds: 3),
                    ),
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
