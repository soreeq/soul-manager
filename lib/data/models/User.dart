class User {
  final String id;
  final String name;
  final DateTime birthDate;
  final String birthPlace;
  final String avatarType;
  final int level;
  final int experience;
  final int spiritualEnergy;

  User({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.birthPlace,
    required this.avatarType,
    this.level = 1,
    this.experience = 0,
    this.spiritualEnergy = 100,
  });
}
