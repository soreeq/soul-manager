import 'package:flutter/material.dart';
import 'services/user_service.dart';
import 'models/user_profile.dart';

class UserState extends ChangeNotifier {
  final UserService _userService = UserService();
  UserProfile? _currentUser;

  // Statyczna lista progów poziomów - dodaj to
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
  double get expBar => _calculateExpBar();
  String get title => _getTitleByLevel(level);

  // Inicjalizacja użytkownika
  Future<void> initializeUser(String userId) async {
    try {
      _currentUser = await _userService.getUserProfile(userId);
      notifyListeners();
    } catch (e) {
      print('Błąd inicjalizacji użytkownika: $e');
    }
  }

  // Utwórz nowego użytkownika
  Future<void> createUser(String userId, String nickname, String birthDate,
      String birthPlace) async {
    try {
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

      await _userService.createUserProfile(newUser);
      _currentUser = newUser;
      notifyListeners();
    } catch (e) {
      print('Błąd tworzenia użytkownika: $e');
    }
  }

  // Ukończ zadanie
  Future<bool> completeTask(int xpReward, int auraChange) async {
    if (_currentUser == null) return false;

    try {
      final newXp = _currentUser!.xp + xpReward;
      final newLevel = _getLevelByXp(newXp);
      final newAura = (_currentUser!.aura + auraChange).clamp(0.0, 100.0);

      await _userService.updateUserProgress(
          _currentUser!.id, newXp, newLevel, newAura);

      _currentUser = _currentUser!.copyWith(
        xp: newXp,
        level: newLevel,
        aura: newAura,
        lastActive: DateTime.now(),
      );

      notifyListeners();
      return newLevel > (_currentUser!.level);
    } catch (e) {
      print('Błąd ukończenia zadania: $e');
      return false;
    }
  }

  // Pomocnicze metody
  double _calculateExpBar() {
    if (_currentUser == null || level >= 10) return 1.0;

    final levelThresholds = [
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
    final currentThreshold = levelThresholds[level - 1];
    final nextThreshold = levelThresholds[level];

    return (xp - currentThreshold) / (nextThreshold - currentThreshold);
  }

  int _getLevelByXp(int xp) {
    final levelThresholds = [
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

// Extension dla UserProfile
extension UserProfileExtension on UserProfile {
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
