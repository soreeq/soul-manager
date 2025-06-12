import 'package:cloud_firestore/cloud_firestore.dart';

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
      elementalEnergies:
          Map<String, double>.from(data['elementalEnergies'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: (data['lastActive'] as Timestamp).toDate(),
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
}
