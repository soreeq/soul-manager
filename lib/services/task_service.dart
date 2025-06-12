import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/spiritual_task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Pobierz wszystkie zadania
  Future<List<SpiritualTaskModel>> getAllTasks() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tasks')
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => SpiritualTaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Błąd podczas pobierania zadań: $e');
    }
  }

  // Dodaj nowe zadanie
  Future<void> addTask(SpiritualTaskModel task) async {
    try {
      await _firestore.collection('tasks').add(task.toFirestore());
    } catch (e) {
      throw Exception('Błąd podczas dodawania zadania: $e');
    }
  }

  // Pobierz zadania według żywiołu
  Future<List<SpiritualTaskModel>> getTasksByElement(String element) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tasks')
          .where('element', isEqualTo: element)
          .get();

      return snapshot.docs
          .map((doc) => SpiritualTaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Błąd podczas pobierania zadań żywiołu: $e');
    }
  }

  // Stream dla real-time aktualizacji zadań
  Stream<List<SpiritualTaskModel>> getTasksStream() {
    return _firestore
        .collection('tasks')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SpiritualTaskModel.fromFirestore(doc))
            .toList());
  }
}
