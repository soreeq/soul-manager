import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Utwórz profil użytkownika
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.toFirestore());
    } catch (e) {
      throw Exception('Błąd podczas tworzenia profilu: $e');
    }
  }

  // Pobierz profil użytkownika
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Błąd podczas pobierania profilu: $e');
    }
  }

  // Aktualizuj XP i poziom
  Future<void> updateUserProgress(
      String userId, int newXp, int newLevel, double newAura) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'xp': newXp,
        'level': newLevel,
        'aura': newAura,
        'lastActive': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Błąd podczas aktualizacji postępu: $e');
    }
  }

  // Aktualizuj energie żywiołów
  Future<void> updateElementalEnergies(
      String userId, Map<String, double> energies) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'elementalEnergies': energies,
        'lastActive': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Błąd podczas aktualizacji energii: $e');
    }
  }

  // Stream dla real-time aktualizacji
  Stream<UserProfile?> getUserProfileStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
  }
}
