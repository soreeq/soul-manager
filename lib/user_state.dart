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
    return UserProfile(
      id: doc.id,
      nickname: data['nickname'] ?? '',
      birthDate: data['birthDate'] ?? '',
      birthPlace: data['birthPlace'] ?? '',
      level: data['level'] ?? 1,
      xp: data['xp'] ?? 0,
      aura: data['aura']?.toDouble() ?? 100.0,
      elementalEnergies: Map<String, double>.from(data['elementalEnergies'] ??
          {
            'Ziemia': 0.0,
            'Ogień': 0.0,
            'Woda': 0.0,
            'Powietrze': 0.0,
          }),
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
  Future<void> initializeUser() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _currentUserId = firebaseUser.uid;
        await _loadUserData();
        _setupRealtimeListener();
      }
    } catch (e) {
      print('Błąd inicjalizacji użytkownika: $e');
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

  // Ukończ zadanie z zapisem do Firebase
  Future<bool> completeTask(int xpReward, int auraChange, String element,
      double elementalEnergy) async {
    if (_currentUser == null || _currentUserId == null) return false;

    try {
      final oldLevel = _currentUser!.level;
      final newXp = _currentUser!.xp + xpReward;
      final newLevel = _getLevelByXp(newXp);
      final newAura = (_currentUser!.aura + auraChange).clamp(0.0, 100.0);

      // Aktualizuj energie żywiołów
      Map<String, double> newElementalEnergies =
          Map.from(_currentUser!.elementalEnergies);
      if (element.isNotEmpty && newElementalEnergies.containsKey(element)) {
        newElementalEnergies[element] =
            (newElementalEnergies[element]! + elementalEnergy)
                .clamp(0.0, 100.0);
      }

      // Zapisz do Firebase
      await _firestore.collection('users').doc(_currentUserId!).update({
        'xp': newXp,
        'level': newLevel,
        'aura': newAura,
        'elementalEnergies': newElementalEnergies,
        'lastActive': FieldValue.serverTimestamp(),
      });

      // Aktualizuj lokalnie (będzie też zaktualizowane przez listener)
      _currentUser = _currentUser!.copyWith(
        xp: newXp,
        level: newLevel,
        aura: newAura,
        elementalEnergies: newElementalEnergies,
        lastActive: DateTime.now(),
      );

      notifyListeners();
      return newLevel > oldLevel;
    } catch (e) {
      print('Błąd ukończenia zadania: $e');
      return false;
    }
  }

  // Aktualizuj aurę
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
}
