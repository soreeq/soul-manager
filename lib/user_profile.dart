import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String nickname;
  final String birthDate;
  final String birthPlace;
  final int level;
  final int xp;
  final double aura;
  final double spiritualLevel;
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
    required this.spiritualLevel,
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
      spiritualLevel: 0,
    );
  }

  // Pomocnicza metoda do bezpiecznej konwersji Map
  static Map<String, double> _convertToDoubleMap(dynamic data) {
    if (data == null) {
      return {
        'fire': 25.0,
        'water': 25.0,
        'earth': 25.0,
        'air': 25.0,
      };
    }

    Map<String, double> result = {};
    if (data is Map) {
      data.forEach((key, value) {
        if (key is String) {
          result[key] = (value ?? 0).toDouble();
        }
      });
    }

    // Upewnij się, że wszystkie elementy są obecne
    result.putIfAbsent('fire', () => 25.0);
    result.putIfAbsent('water', () => 25.0);
    result.putIfAbsent('earth', () => 25.0);
    result.putIfAbsent('air', () => 25.0);

    return result;
  }

  // Pomocnicza metoda do bezpiecznej konwersji Timestamp
  static DateTime? _convertTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) return DateTime.tryParse(timestamp);
    return null;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nickname': nickname,
      'birthDate': birthDate,
      'birthPlace': birthPlace,
      'level': level,
      'xp': xp,
      'aura': aura,
      'spiritualLevel': spiritualLevel,
      'elementalEnergies': elementalEnergies,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
    };
  }

  // Metoda copyWith dla łatwych aktualizacji
  UserProfile copyWith({
    String? nickname,
    String? birthDate,
    String? birthPlace,
    int? level,
    int? xp,
    double? aura,
    double? spiritualLevel,
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
      spiritualLevel: spiritualLevel ?? this.spiritualLevel,
      elementalEnergies: elementalEnergies ?? this.elementalEnergies,
      createdAt: createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  // Metoda do aktualizacji poziomu duchowego na podstawie XP
  UserProfile levelUp() {
    int newLevel = (xp / 100).floor() + 1;
    double newSpiritualLevel = spiritualLevel + 0.1;

    return copyWith(
      level: newLevel,
      spiritualLevel: newSpiritualLevel,
      lastActive: DateTime.now(),
    );
  }

  // Metoda do dodawania XP i aury
  UserProfile addProgress(int xpGain, double auraChange) {
    return copyWith(
      xp: xp + xpGain,
      aura: (aura + auraChange).clamp(0.0, 200.0), // Ograniczenie aury
      lastActive: DateTime.now(),
    );
  }
}
