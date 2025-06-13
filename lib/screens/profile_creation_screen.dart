import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soul_manager/screens/main_screen.dart' as screens;
import 'package:soul_manager/screens/start_screen.dart';
import 'package:soul_manager/main.dart' as app;
import 'package:soul_manager/user_state.dart';
import 'package:soul_manager/firebase_options.dart';

class ProfileCreationScreen extends StatefulWidget {
  @override
  _ProfileCreationScreenState createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthPlaceController = TextEditingController();

  bool _isLogin = true; // Przełącznik między logowaniem a rejestracją
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  void _goBackToStartScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartScreen()),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential;

      if (_isLogin) {
        // Logowanie istniejącego użytkownika
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Pobierz dane użytkownika z Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          // Przekieruj do MainScreen z danymi z Firebase
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => screens.MainScreen(
                nickname: userData['nickname'] ?? '',
                birthDate: userData['birthDate'] ?? '',
                birthPlace: userData['birthPlace'] ?? '',
              ),
            ),
          );

          app.MyApp.scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
          app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text('Witaj ponownie, ${userData['nickname']}!'),
              backgroundColor: Color(0xFFD4AF37),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          throw Exception(
              'Dane użytkownika nie zostały znalezione w bazie danych');
        }
      } else {
        // Rejestracja nowego użytkownika
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Sprawdź czy użytkownik został utworzony
        if (userCredential.user == null) {
          throw Exception('Nie udało się utworzyć konta użytkownika');
        }

        // Zapisz dane użytkownika do Firestore z lepszą obsługą błędów
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'nickname': _nicknameController.text.trim(),
            'birthDate': _birthDateController.text.trim(),
            'birthPlace': _birthPlaceController.text.trim(),
            'email': _emailController.text.trim(),
            'level': 1,
            'xp': 0,
            'aura': 100.0,
            'elementalEnergies': {
              'Ziemia': 0.0,
              'Ogień': 0.0,
              'Woda': 0.0,
              'Powietrze': 0.0,
            },
            'createdAt': FieldValue.serverTimestamp(),
            'lastActive': FieldValue.serverTimestamp(),
          });

          // Przekieruj do MainScreen z danymi
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => screens.MainScreen(
                nickname: _nicknameController.text.trim(),
                birthDate: _birthDateController.text.trim(),
                birthPlace: _birthPlaceController.text.trim(),
              ),
            ),
          );

          app.MyApp.scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
          app.MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content:
                  Text('Profil utworzony! Witaj, ${_nicknameController.text}!'),
              backgroundColor: Color(0xFFD4AF37),
              duration: Duration(seconds: 3),
            ),
          );
        } catch (firestoreError) {
          // Jeśli zapis do Firestore się nie powiódł, usuń utworzone konto
          await userCredential.user!.delete();
          throw Exception(
              'Nie udało się zapisać danych profilu: $firestoreError');
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Hasło jest za słabe. Użyj minimum 6 znaków.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Konto z tym emailem już istnieje.';
          break;
        case 'user-not-found':
          errorMessage = 'Nie znaleziono użytkownika z tym emailem.';
          break;
        case 'wrong-password':
          errorMessage = 'Nieprawidłowe hasło.';
          break;
        case 'invalid-email':
          errorMessage = 'Nieprawidłowy format email.';
          break;
        case 'user-disabled':
          errorMessage = 'To konto zostało zablokowane.';
          break;
        case 'too-many-requests':
          errorMessage = 'Za dużo prób logowania. Spróbuj ponownie później.';
          break;
        case 'network-request-failed':
          errorMessage = 'Brak połączenia z internetem. Sprawdź połączenie.';
          break;
        default:
          errorMessage =
              'Błąd uwierzytelniania: ${e.message ?? 'Nieznany błąd'}';
      }
      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Wystąpił błąd: ${e.toString()}';
      });
      print('Szczegółowy błąd: $e'); // Do debugowania
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dodano tło splash.png jak na innych ekranach
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Własny AppBar z przyciskiem powrotu
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _goBackToStartScreen,
                      icon:
                          Icon(Icons.arrow_back, color: Colors.amber, size: 28),
                      tooltip: 'Powrót do ekranu startowego',
                    ),
                    Expanded(
                      child: Text(
                        _isLogin ? 'Zaloguj się' : 'Utwórz Profil',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          color: Colors.amber,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48), // Wyrównanie tytułu
                  ],
                ),
              ),

              // Główna zawartość
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Karta z przezroczystym tłem dla lepszej czytelności
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E293B).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                  width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isLogin
                                      ? 'Zaloguj się do swojego konta'
                                      : 'Podaj dane do kosmogramu',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),

                                // Wyświetl błąd jeśli wystąpił
                                if (_errorMessage != null) ...[
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.red.withOpacity(0.5)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline,
                                            color: Colors.red, size: 20),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],

                                // Email (zawsze wymagany)
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Colors.amber),
                                    prefixIcon:
                                        Icon(Icons.email, color: Colors.amber),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.amber.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.amber),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFF2C3E50),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Proszę podać email';
                                    }
                                    if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Proszę podać prawidłowy email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),

                                // Hasło (zawsze wymagane)
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Hasło',
                                    labelStyle: TextStyle(color: Colors.amber),
                                    prefixIcon:
                                        Icon(Icons.lock, color: Colors.amber),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.amber.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.amber),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFF2C3E50),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Proszę podać hasło';
                                    }
                                    if (value.length < 6) {
                                      return 'Hasło musi mieć minimum 6 znaków';
                                    }
                                    return null;
                                  },
                                ),

                                // Dodatkowe pola tylko dla rejestracji
                                if (!_isLogin) ...[
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: _nicknameController,
                                    decoration: InputDecoration(
                                      labelText: 'Nickname',
                                      labelStyle:
                                          TextStyle(color: Colors.amber),
                                      prefixIcon: Icon(Icons.person,
                                          color: Colors.amber),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.amber.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.amber),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFF2C3E50),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Proszę podać nickname';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: _birthDateController,
                                    decoration: InputDecoration(
                                      labelText: 'Data urodzenia (RRRR-MM-DD)',
                                      labelStyle:
                                          TextStyle(color: Colors.amber),
                                      prefixIcon: Icon(Icons.calendar_today,
                                          color: Colors.amber),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.amber.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.amber),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFF2C3E50),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Proszę podać datę urodzenia';
                                      }
                                      RegExp dateRegExp =
                                          RegExp(r'^\d{4}-\d{2}-\d{2}$');
                                      if (!dateRegExp.hasMatch(value)) {
                                        return 'Format daty: RRRR-MM-DD';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: _birthPlaceController,
                                    decoration: InputDecoration(
                                      labelText: 'Miejsce urodzenia',
                                      labelStyle:
                                          TextStyle(color: Colors.amber),
                                      prefixIcon: Icon(Icons.location_on,
                                          color: Colors.amber),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.amber.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.amber),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFF2C3E50),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Proszę podać miejsce urodzenia';
                                      }
                                      return null;
                                    },
                                  ),
                                ],

                                SizedBox(height: 24),

                                // Przycisk główny
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFD4AF37),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 16),
                                      elevation: 5,
                                    ),
                                    onPressed: _isLoading ? null : _submitForm,
                                    child: _isLoading
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.black),
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                _isLogin
                                                    ? 'Logowanie...'
                                                    : 'Tworzenie...',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            _isLogin
                                                ? 'Zaloguj się'
                                                : 'Utwórz Profil',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),

                                SizedBox(height: 16),

                                // Przycisk przełączania między logowaniem a rejestracją
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                        _errorMessage = null;
                                        // Wyczyść kontrolery przy przełączaniu
                                        _emailController.clear();
                                        _passwordController.clear();
                                        _nicknameController.clear();
                                        _birthDateController.clear();
                                        _birthPlaceController.clear();
                                      });
                                    },
                                    child: Text(
                                      _isLogin
                                          ? 'Nie masz konta? Zarejestruj się'
                                          : 'Masz już konto? Zaloguj się',
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
