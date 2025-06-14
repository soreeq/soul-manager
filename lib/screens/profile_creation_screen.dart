import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soul_manager/screens/main_screen.dart' as screens;
import 'package:soul_manager/screens/start_screen.dart';
import 'package:soul_manager/main.dart' as app;
import 'package:soul_manager/user_state.dart';

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

  bool _isLogin = true;
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

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

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

        if (userCredential.user == null) {
          throw Exception('Nie udało się utworzyć konta użytkownika');
        }

        // 1. Najpierw utwórz profil użytkownika
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

// TYLKO DO TESTÓW - usuwa wszystkie zadania
        Future<void> _resetAllTasks() async {
          try {
            QuerySnapshot snapshot = await FirebaseFirestore.instance
                .collection('globalTasks')
                .get();

            WriteBatch batch = FirebaseFirestore.instance.batch();
            for (var doc in snapshot.docs) {
              batch.delete(doc.reference);
            }
            await batch.commit();

            // Usuń flagę inicjalizacji
            await FirebaseFirestore.instance
                .collection('system')
                .doc('initialization')
                .delete();

            print('Wszystkie zadania zostały usunięte!');
          } catch (e) {
            print('Błąd resetowania: $e');
          }
        }

        await _resetAllTasks();
        // 2. Automatycznie dodaj wszystkie zadania
        await _addAllTasksToFirestore();

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
        _errorMessage = 'Wystąpił nieoczekiwany błąd: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addAllTasksToFirestore() async {
    try {
      // SPRAWDŹ CZY ZADANIA JUŻ ISTNIEJĄ W BAZIE
      QuerySnapshot existingTasks = await FirebaseFirestore.instance
          .collection('globalTasks')
          .limit(1)
          .get();

      if (existingTasks.docs.isNotEmpty) {
        print('Zadania już istnieją w bazie - pomijam dodawanie');
        return; // Wyjdź z funkcji jeśli zadania już są
      }

      print('Brak zadań w bazie - dodaję wszystkie zadania...');

      final allTasks = [
        // ZADANIA ZIEMI
        {
          "title": "Spacer w Naturze",
          "description": "Idź na 15-minutowy spacer do parku lub lasu",
          "xpReward": 30,
          "element": "Ziemia",
          "elementalEnergy": 20.0,
          "category": "Uziemienie"
        },
        {
          "title": "Ćwiczenie Boso",
          "description": "Stań boso na trawie przez 5 minut",
          "xpReward": 20,
          "element": "Ziemia",
          "elementalEnergy": 15.0,
          "category": "Uziemienie"
        },
        {
          "title": "Dbanie o Rośliny",
          "description": "Podlej rośliny w domu lub ogrodzie",
          "xpReward": 15,
          "element": "Ziemia",
          "elementalEnergy": 10.0,
          "category": "Uziemienie"
        },
        {
          "title": "Ogrodnictwo",
          "description": "Posadź nową roślinę lub przesadź istniejącą",
          "xpReward": 25,
          "element": "Ziemia",
          "elementalEnergy": 18.0,
          "category": "Uziemienie"
        },
        {
          "title": "Zbieranie Kamieni",
          "description":
              "Zbierz 7 kamieni podczas spaceru i stwórz z nich mandałę",
          "xpReward": 20,
          "element": "Ziemia",
          "elementalEnergy": 12.0,
          "category": "Uziemienie"
        },
        {
          "title": "Jedzenie Świadome",
          "description": "Zjedz posiłek w ciszy, skupiając się na smakach",
          "xpReward": 18,
          "element": "Ziemia",
          "elementalEnergy": 14.0,
          "category": "Uziemienie"
        },
        {
          "title": "Medytacja z Kryształami",
          "description": "Medytuj trzymając kryształ przez 10 minut",
          "xpReward": 32,
          "element": "Ziemia",
          "elementalEnergy": 19.0,
          "category": "Uziemienie"
        },
        {
          "title": "Chodzenie po Górach",
          "description": "Idź na górską wędrówkę lub wzgórze",
          "xpReward": 40,
          "element": "Ziemia",
          "elementalEnergy": 25.0,
          "category": "Uziemienie"
        },
        {
          "title": "Przytulanie Drzewa",
          "description": "Przytul drzewo przez 5 minut, czując jego energię",
          "xpReward": 24,
          "element": "Ziemia",
          "elementalEnergy": 16.0,
          "category": "Uziemienie"
        },
        {
          "title": "Tworzenie z Gliny",
          "description": "Ulepić coś z gliny lub plasteliny",
          "xpReward": 26,
          "element": "Ziemia",
          "elementalEnergy": 17.0,
          "category": "Uziemienie"
        },
        {
          "title": "Sprzątanie Świadome",
          "description": "Posprzątaj pokój z pełną uwagą",
          "xpReward": 20,
          "element": "Ziemia",
          "elementalEnergy": 12.0,
          "category": "Uziemienie"
        },
        {
          "title": "Gotowanie Intuicyjne",
          "description": "Ugotuj posiłek bez przepisu, słuchając intuicji",
          "xpReward": 28,
          "element": "Ziemia",
          "elementalEnergy": 18.0,
          "category": "Uziemienie"
        },

        // ZADANIA OGNIA
        {
          "title": "Dziennik Kreatywny",
          "description": "Zapisz 3 pomysły lub myśli bez oceniania",
          "xpReward": 25,
          "element": "Ogień",
          "elementalEnergy": 15.0,
          "category": "Inspiracja"
        },
        {
          "title": "Rysunek Intuicyjny",
          "description": "Narysuj coś odzwierciedlającego Twój nastrój",
          "xpReward": 20,
          "element": "Ogień",
          "elementalEnergy": 10.0,
          "category": "Inspiracja"
        },
        {
          "title": "Taniec Wyrażenia",
          "description": "Tańcz przez 5 minut, wyrażając emocje",
          "xpReward": 30,
          "element": "Ogień",
          "elementalEnergy": 12.0,
          "category": "Inspiracja"
        },
        {
          "title": "Śpiewanie Mantry",
          "description": "Śpiewaj wybraną mantrę przez 10 minut",
          "xpReward": 28,
          "element": "Ogień",
          "elementalEnergy": 16.0,
          "category": "Inspiracja"
        },
        {
          "title": "Wizualizacja Celów",
          "description": "Wizualizuj swoje cele przez 15 minut",
          "xpReward": 35,
          "element": "Ogień",
          "elementalEnergy": 20.0,
          "category": "Inspiracja"
        },
        {
          "title": "Pisanie Afirmacji",
          "description": "Napisz 5 pozytywnych afirmacji o sobie",
          "xpReward": 22,
          "element": "Ogień",
          "elementalEnergy": 13.0,
          "category": "Inspiracja"
        },
        {
          "title": "Palenie Kadzidła",
          "description": "Zapal kadzidło i medytuj nad płomieniem",
          "xpReward": 26,
          "element": "Ogień",
          "elementalEnergy": 14.0,
          "category": "Inspiracja"
        },
        {
          "title": "Pisanie Listu do Siebie",
          "description": "Napisz list do siebie z przyszłości",
          "xpReward": 24,
          "element": "Ogień",
          "elementalEnergy": 15.0,
          "category": "Inspiracja"
        },
        {
          "title": "Ćwiczenia Energetyczne",
          "description": "Wykonaj 15 minut ćwiczeń fizycznych",
          "xpReward": 30,
          "element": "Ogień",
          "elementalEnergy": 18.0,
          "category": "Inspiracja"
        },
        {
          "title": "Tworzenie Kolażu",
          "description": "Stwórz kolaż swoich marzeń",
          "xpReward": 28,
          "element": "Ogień",
          "elementalEnergy": 16.0,
          "category": "Inspiracja"
        },
        {
          "title": "Improwizacja Muzyczna",
          "description": "Graj na instrumencie lub śpiewaj improwizując",
          "xpReward": 32,
          "element": "Ogień",
          "elementalEnergy": 19.0,
          "category": "Inspiracja"
        },
        {
          "title": "Ćwiczenie Woli",
          "description": "Zrób coś trudnego, co odkładałeś",
          "xpReward": 35,
          "element": "Ogień",
          "elementalEnergy": 22.0,
          "category": "Inspiracja"
        },

        // ZADANIA WODY
        {
          "title": "Medytacja przy Wodzie",
          "description": "Medytuj przez 10 minut przy wodzie",
          "xpReward": 35,
          "element": "Woda",
          "elementalEnergy": 20.0,
          "category": "Spokój"
        },
        {
          "title": "Kąpiel Oczyszczająca",
          "description": "Weź kąpiel z solą, wizualizując oczyszczenie",
          "xpReward": 25,
          "element": "Woda",
          "elementalEnergy": 15.0,
          "category": "Spokój"
        },
        {
          "title": "Wdzięczność za Emocje",
          "description":
              "Zapisz 3 rzeczy związane z emocjami, za które jesteś wdzięczny",
          "xpReward": 20,
          "element": "Woda",
          "elementalEnergy": 10.0,
          "category": "Spokój"
        },
        {
          "title": "Płukanie Energetyczne",
          "description":
              "Weź prysznic, wizualizując zmywanie negatywnej energii",
          "xpReward": 18,
          "element": "Woda",
          "elementalEnergy": 12.0,
          "category": "Spokój"
        },
        {
          "title": "Picie Świadomie",
          "description": "Wypij szklankę wody, skupiając się na każdym łyku",
          "xpReward": 15,
          "element": "Woda",
          "elementalEnergy": 8.0,
          "category": "Spokój"
        },
        {
          "title": "Łzy Uwolnienia",
          "description": "Pozwól sobie na płacz, jeśli tego potrzebujesz",
          "xpReward": 30,
          "element": "Woda",
          "elementalEnergy": 18.0,
          "category": "Spokój"
        },
        {
          "title": "Medytacja pod Prysznicem",
          "description": "Medytuj podczas brania prysznica",
          "xpReward": 22,
          "element": "Woda",
          "elementalEnergy": 13.0,
          "category": "Spokój"
        },
        {
          "title": "Pisanie Listów Przebaczenia",
          "description": "Napisz list przebaczenia (nie musisz go wysyłać)",
          "xpReward": 35,
          "element": "Woda",
          "elementalEnergy": 20.0,
          "category": "Spokój"
        },
        {
          "title": "Słuchanie Deszczu",
          "description": "Słuchaj dźwięków deszczu przez 10 minut",
          "xpReward": 20,
          "element": "Woda",
          "elementalEnergy": 12.0,
          "category": "Spokój"
        },
        {
          "title": "Masaż Stóp w Wodzie",
          "description": "Namocz stopy w ciepłej wodzie i je wymasuj",
          "xpReward": 25,
          "element": "Woda",
          "elementalEnergy": 15.0,
          "category": "Spokój"
        },
        {
          "title": "Dziennik Emocji",
          "description": "Zapisz swoje emocje z ostatnich 24 godzin",
          "xpReward": 28,
          "element": "Woda",
          "elementalEnergy": 16.0,
          "category": "Spokój"
        },
        {
          "title": "Uwalnianie Żalu",
          "description": "Napisz żale na papierze i puść je w wodzie",
          "xpReward": 32,
          "element": "Woda",
          "elementalEnergy": 19.0,
          "category": "Spokój"
        },

        // ZADANIA POWIETRZA
        {
          "title": "Ćwiczenie Oddechowe",
          "description": "Wykonaj 5-minutowe głębokie oddychanie",
          "xpReward": 25,
          "element": "Powietrze",
          "elementalEnergy": 15.0,
          "category": "Intuicja"
        },
        {
          "title": "Tarot lub Runy",
          "description": "Wyciągnij kartę tarota i zapisz przesłanie",
          "xpReward": 20,
          "element": "Powietrze",
          "elementalEnergy": 10.0,
          "category": "Intuicja"
        },
        {
          "title": "Słuchanie Ciszy",
          "description": "Spędź 5 minut w całkowitej ciszy",
          "xpReward": 30,
          "element": "Powietrze",
          "elementalEnergy": 12.0,
          "category": "Intuicja"
        },
        {
          "title": "Medytacja Chodzenia",
          "description":
              "Chodź powoli przez 10 minut, skupiając się na oddechu",
          "xpReward": 28,
          "element": "Powietrze",
          "elementalEnergy": 16.0,
          "category": "Intuicja"
        },
        {
          "title": "Obserwacja Chmur",
          "description": "Leż i obserwuj chmury przez 15 minut",
          "xpReward": 22,
          "element": "Powietrze",
          "elementalEnergy": 14.0,
          "category": "Intuicja"
        },
        {
          "title": "Dziennik Snów",
          "description": "Zapisz swój ostatni sen i jego interpretację",
          "xpReward": 25,
          "element": "Powietrze",
          "elementalEnergy": 13.0,
          "category": "Intuicja"
        },
        {
          "title": "Medytacja z Dzwoneczkami",
          "description": "Medytuj słuchając dzwoneczków tybetańskich",
          "xpReward": 30,
          "element": "Powietrze",
          "elementalEnergy": 17.0,
          "category": "Intuicja"
        },
        {
          "title": "Pisanie Automatyczne",
          "description": "Pisz przez 10 minut nie kontrolując myśli",
          "xpReward": 26,
          "element": "Powietrze",
          "elementalEnergy": 15.0,
          "category": "Intuicja"
        },
        {
          "title": "Obserwacja Ptaków",
          "description": "Obserwuj ptaki przez 15 minut",
          "xpReward": 22,
          "element": "Powietrze",
          "elementalEnergy": 13.0,
          "category": "Intuicja"
        },
        {
          "title": "Ćwiczenie Telepatii",
          "description": "Spróbuj wysłać myśl do kogoś bliskiego",
          "xpReward": 28,
          "element": "Powietrze",
          "elementalEnergy": 16.0,
          "category": "Intuicja"
        },
        {
          "title": "Medytacja na Wietrze",
          "description": "Medytuj na zewnątrz, czując wiatr na skórze",
          "xpReward": 32,
          "element": "Powietrze",
          "elementalEnergy": 18.0,
          "category": "Intuicja"
        },
        {
          "title": "Interpretacja Znaków",
          "description": "Szukaj znaków od Wszechświata przez cały dzień",
          "xpReward": 35,
          "element": "Powietrze",
          "elementalEnergy": 20.0,
          "category": "Intuicja"
        },
      ];

      // Użyj batch do efektywnego dodawania
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var task in allTasks) {
        DocumentReference docRef =
            FirebaseFirestore.instance.collection('globalTasks').doc();
        batch.set(docRef, {
          ...task,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
          'isCustom': false,
          'addedBy': 'system', // Oznacz jako zadania systemowe
        });
      }

      await batch.commit();
      print('${allTasks.length} zadań zostało dodanych do Firestore!');
    } catch (e) {
      print('Błąd dodawania zadań: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                          child: Text(_errorMessage!,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],
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
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                        _errorMessage = null;
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
