import 'package:flutter/material.dart';

class UserState {
  int xp = 0;
  int level = 1;
  double expBar = 0.0; // Procent paska XP (0.0 do 1.0)
  int aura = 100; // Początkowa aura (maksymalnie 100)
  String title = 'Adept Początkujący';

  // Progi XP dla poziomów
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
  static const List<String> levelTitles = [
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

  // Obliczanie poziomu na podstawie XP
  int getLevelByXp(int xp) {
    int level = 1;
    for (int threshold in levelThresholds) {
      if (xp >= threshold) {
        level++;
      } else {
        break;
      }
    }
    return level > 10 ? 10 : level - 1;
  }

  // Zwracanie tytułu na podstawie poziomu
  String getTitleByLevel(int level) {
    if (level < 1) return 'Nieznany poziom';
    if (level > 10) return 'Mentor Wieczności';
    return levelTitles[level - 1];
  }

  // Ukończenie zadania i aktualizacja stanu
  bool completeTask(int taskXp, int taskAura) {
    xp += taskXp;
    int newLevel = getLevelByXp(xp);
    bool levelUp = newLevel > level;
    level = newLevel;
    title = getTitleByLevel(level);

    // Obliczanie paska XP względem progów
    if (level == 10) {
      expBar = 1.0;
    } else {
      int lowerBound = levelThresholds[level - 1];
      int upperBound = levelThresholds[level];
      expBar = (xp - lowerBound) / (upperBound - lowerBound);
    }

    // Aktualizacja aury
    aura += taskAura;
    if (aura > 100) {
      aura = 100;
    }

    return levelUp;
  }
}
