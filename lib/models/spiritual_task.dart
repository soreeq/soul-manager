import 'package:cloud_firestore/cloud_firestore.dart';

class SpiritualTaskModel {
  final String id;
  final String title;
  final String description;
  final String element;
  final int xpReward;
  final double elementalEnergy;
  final String category;
  final bool isCustom;
  final String? createdBy;
  final DateTime createdAt;

  SpiritualTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.element,
    required this.xpReward,
    required this.elementalEnergy,
    required this.category,
    this.isCustom = false,
    this.createdBy,
    required this.createdAt,
  });

  factory SpiritualTaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SpiritualTaskModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      element: data['element'],
      xpReward: data['xpReward'],
      elementalEnergy: data['elementalEnergy']?.toDouble(),
      category: data['category'],
      isCustom: data['isCustom'] ?? false,
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'element': element,
      'xpReward': xpReward,
      'elementalEnergy': elementalEnergy,
      'category': category,
      'isCustom': isCustom,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
