import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soul_manager/screens/dashboard_screen.dart';

// Zaktualizowana klasa ReflectionEntry z ID
class ReflectionEntry {
  final String? id;
  final String text;
  final String type;
  final DateTime date;

  ReflectionEntry({
    this.id,
    required this.text,
    required this.type,
    required this.date,
  });

  Color get color =>
      type == 'reflection' ? Colors.blue.shade100 : Colors.green.shade100;
}

// Model UserProfile
class UserProfile {
  final String id;
  final String nickname;
  final String birthDate;
  final String birthPlace;
  final int level;
  final int xp;
  final double aura;
  final Map<String, double> elementalEnergies;
  final DateTime createdAt;
  final DateTime lastActive;

  UserProfile({
    required this.id,
    required this.nickname,
    required this.birthDate,
    required this.birthPlace,
    required this.level,
    required this.xp,
    required this.aura,
    required this.elementalEnergies,
    required this.createdAt,
    required this.lastActive,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Bezpieczne konwersje typów
    Map<String, double> elementalEnergiesMap = {};
    if (data['elementalEnergies'] != null) {
      Map<String, dynamic> energiesData =
          Map<String, dynamic>.from(data['elementalEnergies']);
      energiesData.forEach((key, value) {
        elementalEnergiesMap[key] =
            (value is int) ? value.toDouble() : (value as double? ?? 0.0);
      });
    } else {
      elementalEnergiesMap = {
        'Ziemia': 0.0,
        'Ogień': 0.0,
        'Woda': 0.0,
        'Powietrze': 0.0,
      };
    }

    return UserProfile(
      id: doc.id,
      nickname: data['nickname'] ?? '',
      birthDate: data['birthDate'] ?? '',
      birthPlace: data['birthPlace'] ?? '',
      level: data['level'] ?? 1,
      xp: data['xp'] ?? 0,
      aura: (data['aura'] is int)
          ? (data['aura'] as int).toDouble()
          : (data['aura'] as double? ?? 100.0),
      elementalEnergies: elementalEnergiesMap,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastActive: data['lastActive'] != null
          ? (data['lastActive'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nickname': nickname,
      'birthDate': birthDate,
      'birthPlace': birthPlace,
      'level': level,
      'xp': xp,
      'aura': aura,
      'elementalEnergies': elementalEnergies,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
    };
  }

  UserProfile copyWith({
    String? nickname,
    String? birthDate,
    String? birthPlace,
    int? level,
    int? xp,
    double? aura,
    Map<String, double>? elementalEnergies,
    DateTime? lastActive,
  }) {
    return UserProfile(
      id: id,
      nickname: nickname ?? this.nickname,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      aura: aura ?? this.aura,
      elementalEnergies: elementalEnergies ?? this.elementalEnergies,
      createdAt: createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}

class UserState extends ChangeNotifier {
  Future<void> addCompletedTask(SpiritualTask task) async {
    if (_currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_currentUserId!)
          .collection('completedTasks')
          .add({
        'title': task.title,
        'description': task.description,
        'element': task.element,
        'xpReward': task.xpReward,
        'elementalEnergy': task.elementalEnergy,
        'category': task.category,
        'completedAt': FieldValue.serverTimestamp(),
        'userId': _currentUserId,
      });
    } catch (e) {
      print('Błąd dodawania ukończonego zadania: $e');
    }
  }

  // Dodaj również metodę do pobierania ukończonych zadań
  Stream<List<CompletedTask>> getCompletedTasksStream() {
    if (_currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_currentUserId!)
        .collection('completedTasks')
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              return CompletedTask(
                id: doc.id, // Przekaż ID dokumentu z Firebase
                title: data['title'] ?? '',
                element: data['element'] ?? '',
                xpReward: data['xpReward'] ?? 0,
                elementalEnergy: data['elementalEnergy']?.toDouble() ?? 0.0,
                completedAt: data['completedAt'] != null
                    ? (data['completedAt'] as Timestamp).toDate()
                    : DateTime.now(),
              );
            }).toList());
  }

  // Pobierz liczbę dzisiejszych zadań
  Future<int> getTodayCompletedTasksCount() async {
    if (_currentUserId == null) return 0;

    try {
      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_currentUserId!)
          .collection('completedTasks')
          .where('completedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('completedAt', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Błąd pobierania liczby zadań: $e');
      return 0;
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserProfile? _currentUser;
  String? _currentUserId;

  // Statyczna lista progów poziomów
  static const List<int> levelThresholds = [
    0,
    100,
    170,
    288,
    491,
    835,
    1419,
    2413,
    4103,
    6975
  ];

  // Gettery
  UserProfile? get currentUser => _currentUser;
  int get xp => _currentUser?.xp ?? 0;
  int get level => _currentUser?.level ?? 1;
  double get aura => _currentUser?.aura ?? 100.0;
  Map<String, double> get elementalEnergies =>
      _currentUser?.elementalEnergies ??
      {
        'Ziemia': 0.0,
        'Ogień': 0.0,
        'Woda': 0.0,
        'Powietrze': 0.0,
      };
  double get expBar => _calculateExpBar();
  String get title => _getTitleByLevel(level);

  // Inicjalizacja użytkownika z Firebase Auth
  // Zaktualizowana metoda initializeUser
  Future<void> initializeUser() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _currentUserId = firebaseUser.uid;

        // Sprawdź połączenie z Firestore
        await _firestore.enableNetwork();

        await _loadUserData();
        _setupRealtimeListener();

        // Bezpiecznie oblicz i zapisz znak zodiaku
        await _calculateAndSaveZodiacSign();
      }
    } catch (e) {
      print('Błąd inicjalizacji użytkownika: $e');
      // Spróbuj ponownie po 2 sekundach
      Future.delayed(Duration(seconds: 2), () => initializeUser());
    }
  }

  // Ładowanie danych użytkownika z Firestore
  Future<void> _loadUserData() async {
    if (_currentUserId == null) return;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(_currentUserId!).get();

      if (doc.exists) {
        _currentUser = UserProfile.fromFirestore(doc);
        notifyListeners();
      }
    } catch (e) {
      print('Błąd ładowania danych użytkownika: $e');
    }
  }

  // Nasłuchiwanie zmian w czasie rzeczywistym
  void _setupRealtimeListener() {
    if (_currentUserId == null) return;

    _firestore
        .collection('users')
        .doc(_currentUserId!)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        _currentUser = UserProfile.fromFirestore(doc);
        notifyListeners();
      }
    });
  }

  // Utwórz nowego użytkownika
  Future<void> createUser(String userId, String nickname, String birthDate,
      String birthPlace) async {
    try {
      _currentUserId = userId;
      final newUser = UserProfile(
        id: userId,
        nickname: nickname,
        birthDate: birthDate,
        birthPlace: birthPlace,
        level: 1,
        xp: 0,
        aura: 100.0,
        elementalEnergies: {
          'Ziemia': 0.0,
          'Ogień': 0.0,
          'Woda': 0.0,
          'Powietrze': 0.0,
        },
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .set(newUser.toFirestore());
      _currentUser = newUser;
      _setupRealtimeListener();
      notifyListeners();
    } catch (e) {
      print('Błąd tworzenia użytkownika: $e');
    }
  }

  // Bezpieczne wykonywanie operacji Firebase
  Future<void> _performFirebaseOperationSafely(
      Future<void> Function() operation) async {
    try {
      await operation();
    } catch (e) {
      print('Błąd operacji Firebase: $e');
      // Nie blokuj UI w przypadku błędu
    }
  }

  // Ukończ zadanie z zapisem do Firebase
  Future<bool> completeTask(int xpReward, int auraChange, String element,
      double elementalEnergy) async {
    if (_currentUser == null || _currentUserId == null) return false;

    try {
      final oldLevel = _currentUser!.level;
      final newXp = _currentUser!.xp + xpReward;
      final newLevel = _getLevelByXp(newXp);
      final newAura = (_currentUser!.aura + auraChange).clamp(0.0, 100.0);

      Map<String, double> newElementalEnergies =
          Map.from(_currentUser!.elementalEnergies);
      if (element.isNotEmpty && newElementalEnergies.containsKey(element)) {
        newElementalEnergies[element] =
            (newElementalEnergies[element]! + elementalEnergy)
                .clamp(0.0, 100.0);
      }

      // Aktualizuj lokalnie natychmiast (dla responsywności UI)
      _currentUser = _currentUser!.copyWith(
        xp: newXp,
        level: newLevel,
        aura: newAura,
        elementalEnergies: newElementalEnergies,
        lastActive: DateTime.now(),
      );

      notifyListeners();

      // Wykonaj operację Firebase w tle
      await _performFirebaseOperationSafely(() async {
        await _firestore.collection('users').doc(_currentUserId!).update({
          'xp': newXp,
          'level': newLevel,
          'aura': newAura,
          'elementalEnergies': newElementalEnergies,
          'lastActive': FieldValue.serverTimestamp(),
        });
      });

      return newLevel > oldLevel;
    } catch (e) {
      print('Błąd ukończenia zadania: $e');
      return false;
    }
  }

  // Dodaj refleksję do Firebase
  Future<void> addReflection(String text, String type) async {
    if (_currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_currentUserId!)
          .collection('reflections')
          .add({
        'text': text,
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': _currentUserId,
      });

      // Dodaj XP za refleksję
      await completeTask(10, 0, '', 0.0);
    } catch (e) {
      print('Błąd dodawania refleksji: $e');
    }
  }

  // Pobierz refleksje z Firebase
  Stream<List<ReflectionEntry>> getReflectionsStream() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_currentUserId!)
        .collection('reflections')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              return ReflectionEntry(
                id: doc.id,
                text: data['text'] ?? '',
                type: data['type'] ?? 'reflection',
                date: data['createdAt'] != null
                    ? (data['createdAt'] as Timestamp).toDate()
                    : DateTime.now(),
              );
            }).toList());
  }

  // Usuń refleksję
  Future<void> deleteReflection(String reflectionId) async {
    if (_currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_currentUserId!)
          .collection('reflections')
          .doc(reflectionId)
          .delete();
    } catch (e) {
      print('Błąd usuwania refleksji: $e');
    }
  }

  // Pomocnicze metody
  double _calculateExpBar() {
    if (_currentUser == null || level >= 10) return 1.0;

    final currentThreshold = levelThresholds[level - 1];
    final nextThreshold = levelThresholds[level];

    return (xp - currentThreshold) / (nextThreshold - currentThreshold);
  }

  int _getLevelByXp(int xp) {
    for (int i = levelThresholds.length - 1; i >= 0; i--) {
      if (xp >= levelThresholds[i]) {
        return i + 1;
      }
    }
    return 1;
  }

  String _getTitleByLevel(int level) {
    final titles = [
      'Adept Początkujący',
      'Adept Żywiołów',
      'Adept Intuicji',
      'Adept Harmonii',
      'Adept Gwiazd',
      'Adept Mądrości',
      'Adept Światła',
      'Adept Kosmosu',
      'Adept Przebudzenia',
      'Adept Wieczności',
    ];

    return titles[level.clamp(1, 10) - 1];
  }

  Future<void> _calculateAndSaveZodiacSign() async {
    if (_currentUser?.birthDate.isNotEmpty == true && _currentUserId != null) {
      try {
        String zodiacSign = _getZodiacSign(_currentUser!.birthDate);
        await _firestore.collection('users').doc(_currentUserId!).update({
          'zodiacSign': zodiacSign,
        });
      } catch (e) {
        print('Błąd zapisywania znaku zodiaku: $e');
      }
    }
  }

  String _getZodiacSign(String birthDate) {
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
      print('Błąd obliczania znaku zodiaku: $e');
      return 'Nieznany';
    }
    return 'Nieznany';
  }

  // Dodaj do getterów w UserState:
  String get zodiacSign {
    if (_currentUser?.birthDate.isNotEmpty == true) {
      return _getZodiacSign(_currentUser!.birthDate);
    }
    return 'Nieznany';
  }

  String get zodiacEmoji {
    switch (zodiacSign) {
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

// Dodaj do klasy UserState
  Future<void> importTasksToFirestore() async {
    try {
      final tasks = [
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
        }
      ];

      for (var task in tasks) {
        await _firestore.collection('globalTasks').add({
          ...task,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      }
      print('Zadania zaimportowane do Firestore!');
    } catch (e) {
      print('Błąd importu zadań: $e');
    }
  }

  Future<void> addCompletedTaskFromModel(SpiritualTaskModel task) async {
    if (_currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_currentUserId!)
          .collection('completedTasks')
          .add({
        'title': task.title,
        'description': task.description,
        'element': task.element,
        'xpReward': task.xpReward,
        'elementalEnergy': task.elementalEnergy,
        'category': task.category,
        'taskId': task.id,
        'completedAt': FieldValue.serverTimestamp(),
        'userId': _currentUserId,
      });
    } catch (e) {
      print('Błąd dodawania ukończonego zadania: $e');
    }
  }

  // DODAJ TĘ METODĘ - zużywanie aury
  Future<void> consumeAura(double amount) async {
    if (_currentUserId == null) return;

    try {
      double newAura = (aura - amount).clamp(0.0, 100.0);

      // Aktualizuj lokalnie natychmiast
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          aura: newAura,
          lastActive: DateTime.now(),
        );
        notifyListeners();
      }

      // Zapisz do Firebase
      await _firestore.collection('users').doc(_currentUserId!).update({
        'aura': newAura,
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Błąd zużywania aury: $e');
    }
  }

  // DODAJ TĘ METODĘ - regeneracja aury
  Future<void> updateAura(double newAura) async {
    if (_currentUser == null || _currentUserId == null) return;

    try {
      await _firestore.collection('users').doc(_currentUserId!).update({
        'aura': newAura.clamp(0.0, 100.0),
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Błąd aktualizacji aury: $e');
    }
  }

  // Dodaj do klasy UserState
  Future<void> importExpandedTasksToFirestore() async {
    try {
      final expandedTasks = [
        // ISTNIEJĄCE ZADANIA ZIEMI
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

        // ISTNIEJĄCE ZADANIA OGNIA
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

        // ISTNIEJĄCE ZADANIA WODY
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

        // ISTNIEJĄCE ZADANIA POWIETRZA
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

        // NOWE ZADANIA ZIEMI
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

        // NOWE ZADANIA OGNIA
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

        // NOWE ZADANIA WODY
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

        // NOWE ZADANIA POWIETRZA
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

      for (var task in expandedTasks) {
        await _firestore.collection('globalTasks').add({
          ...task,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
          'isCustom': false,
        });
      }
      print('Rozszerzona lista zadań zaimportowana do Firestore!');
    } catch (e) {
      print('Błąd importu rozszerzonych zadań: $e');
    }
  }
}
