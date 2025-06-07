class SpiritualTask {
  final String id;
  final String title;
  final String description;
  final TaskType type;
  final int energyReward;
  final int experienceReward;
  final bool isCompleted;
  final DateTime createdAt;

  SpiritualTask({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.energyReward,
    required this.experienceReward,
    this.isCompleted = false,
    required this.createdAt,
  });
}

enum TaskType { meditation, grounding, nature, creativity, balance }
