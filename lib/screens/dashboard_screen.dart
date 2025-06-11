import 'package:flutter/material.dart';
import 'package:soul_manager/screens/tasks_screen.dart';
import 'dart:async';
import 'dart:math';
import '../main.dart'; // Dostęp do globalnego klucza ScaffoldMessenger
import '../user_state.dart'; // Dostęp do stanu użytkownika

class ReflectionEntry {
  final String text;
  final String type; // 'reflection' lub 'gratitude'
  final DateTime date;

  ReflectionEntry(this.text, this.type, this.date);

  Color get color =>
      type == 'reflection' ? Colors.blue.shade100 : Colors.green.shade100;
}

class ReflectionJournal {
  static final List<ReflectionEntry> _entries = [];

  static List<ReflectionEntry> get entries => _entries;

  static void addEntry(String text, String type) {
    _entries.insert(0, ReflectionEntry(text, type, DateTime.now()));
  }
}

class CompletedTask {
  final String title;
  final String element;
  final int xpReward;
  final double elementalEnergy;
  final DateTime completedAt;

  CompletedTask({
    required this.title,
    required this.element,
    required this.xpReward,
    required this.elementalEnergy,
    required this.completedAt,
  });
}

class CompletedTasksManager {
  static final List<CompletedTask> _completedTasks = [];

  static List<CompletedTask> get completedTasks => _completedTasks;

  static void addCompletedTask(SpiritualTask task) {
    _completedTasks.add(CompletedTask(
      title: task.title,
      element: task.element,
      xpReward: task.xpReward,
      elementalEnergy: task.elementalEnergy,
      completedAt: DateTime.now(),
    ));
  }

  static int getTodayCompletedCount() {
    final today = DateTime.now();
    return _completedTasks.where((task) {
      return task.completedAt.year == today.year &&
          task.completedAt.month == today.month &&
          task.completedAt.day == today.day;
    }).length;
  }
}

class ElementalEnergy {
  static Map<String, double> energies = {
    'Ziemia': 0.0,
    'Ogień': 0.0,
    'Woda': 0.0,
    'Powietrze': 0.0,
  };

  static const double maxEnergyPerDay = 100.0;

  static void addEnergy(String element, double amount) {
    if (energies.containsKey(element)) {
      energies[element] =
          (energies[element]! + amount).clamp(0.0, maxEnergyPerDay);
    }
  }

  static Color getElementColor(String element) {
    switch (element) {
      case 'Ziemia':
        return Colors.green;
      case 'Ogień':
        return Colors.red;
      case 'Woda':
        return Colors.blue;
      case 'Powietrze':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  static IconData getElementIcon(String element) {
    switch (element) {
      case 'Ziemia':
        return Icons.terrain;
      case 'Ogień':
        return Icons.local_fire_department;
      case 'Woda':
        return Icons.water_drop;
      case 'Powietrze':
        return Icons.air;
      default:
        return Icons.circle;
    }
  }
}

class SpiritualTask {
  final String title;
  final String description;
  final int xpReward;
  final String element;
  final double elementalEnergy;
  final String category;

  SpiritualTask({
    required this.title,
    required this.description,
    required this.xpReward,
    required this.element,
    required this.elementalEnergy,
    required this.category,
  });
}

class TaskManager {
  static final List<SpiritualTask> allTasks = [
    // Uziemienie (Energia Ziemi)
    SpiritualTask(
      title: 'Spacer w Naturze',
      description: 'Idź na 15-minutowy spacer do parku lub lasu',
      xpReward: 30,
      element: 'Ziemia',
      elementalEnergy: 20.0,
      category: 'Uziemienie',
    ),
    SpiritualTask(
      title: 'Ćwiczenie Boso',
      description: 'Stań boso na trawie przez 5 minut',
      xpReward: 20,
      element: 'Ziemia',
      elementalEnergy: 15.0,
      category: 'Uziemienie',
    ),
    SpiritualTask(
      title: 'Dbanie o Rośliny',
      description: 'Podlej rośliny w domu lub ogrodzie',
      xpReward: 15,
      element: 'Ziemia',
      elementalEnergy: 10.0,
      category: 'Uziemienie',
    ),

    // Inspiracja (Energia Ognia)
    SpiritualTask(
      title: 'Dziennik Kreatywny',
      description: 'Zapisz 3 pomysły lub myśli bez oceniania',
      xpReward: 25,
      element: 'Ogień',
      elementalEnergy: 15.0,
      category: 'Inspiracja',
    ),
    SpiritualTask(
      title: 'Rysunek Intuicyjny',
      description: 'Narysuj coś odzwierciedlającego Twój nastrój',
      xpReward: 20,
      element: 'Ogień',
      elementalEnergy: 10.0,
      category: 'Inspiracja',
    ),
    SpiritualTask(
      title: 'Taniec Wyrażenia',
      description: 'Tańcz przez 5 minut, wyrażając emocje',
      xpReward: 30,
      element: 'Ogień',
      elementalEnergy: 12.0,
      category: 'Inspiracja',
    ),

    // Spokój (Energia Wody)
    SpiritualTask(
      title: 'Medytacja przy Wodzie',
      description: 'Medytuj przez 10 minut przy wodzie',
      xpReward: 35,
      element: 'Woda',
      elementalEnergy: 20.0,
      category: 'Spokój',
    ),
    SpiritualTask(
      title: 'Kąpiel Oczyszczająca',
      description: 'Weź kąpiel z solą, wizualizując oczyszczenie',
      xpReward: 25,
      element: 'Woda',
      elementalEnergy: 15.0,
      category: 'Spokój',
    ),
    SpiritualTask(
      title: 'Wdzięczność za Emocje',
      description:
          'Zapisz 3 rzeczy związane z emocjami, za które jesteś wdzięczny',
      xpReward: 20,
      element: 'Woda',
      elementalEnergy: 10.0,
      category: 'Spokój',
    ),

    // Intuicja (Energia Powietrza)
    SpiritualTask(
      title: 'Ćwiczenie Oddechowe',
      description: 'Wykonaj 5-minutowe głębokie oddychanie',
      xpReward: 25,
      element: 'Powietrze',
      elementalEnergy: 15.0,
      category: 'Intuicja',
    ),
    SpiritualTask(
      title: 'Tarot lub Runy',
      description: 'Wyciągnij kartę tarota i zapisz przesłanie',
      xpReward: 20,
      element: 'Powietrze',
      elementalEnergy: 10.0,
      category: 'Intuicja',
    ),
    SpiritualTask(
      title: 'Słuchanie Ciszy',
      description: 'Spędź 5 minut w całkowitej ciszy',
      xpReward: 30,
      element: 'Powietrze',
      elementalEnergy: 12.0,
      category: 'Intuicja',
    ),
  ];

  static SpiritualTask getRandomTask() {
    final random = Random();
    return allTasks[random.nextInt(allTasks.length)];
  }
}

class AuraManager {
  static double aura = 100.0;
  static DateTime lastUpdate = DateTime.now();
  static Timer? _timer;

  static const double maxAura = 100.0;
  static const double auraDropPerTask = 100.0 / 15.0;
  static const double regenPerHour = 10.0;

  static void initTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: 1), (_) => updateAura());
  }

  static void updateAura() {
    if (aura < maxAura) {
      final now = DateTime.now();
      final elapsed = now.difference(lastUpdate).inSeconds / 3600.0;
      aura = (aura + elapsed * regenPerHour).clamp(0.0, maxAura);
      lastUpdate = now;
    }
  }

  static void consumeAura() {
    if (aura >= auraDropPerTask) {
      aura -= auraDropPerTask;
      lastUpdate = DateTime.now();
    }
  }

  static Duration timeToFull() {
    if (aura >= maxAura) return Duration.zero;
    final missing = maxAura - aura;
    final hours = missing / regenPerHour;
    return Duration(
      hours: hours.floor(),
      minutes: ((hours - hours.floor()) * 60).round(),
      seconds: (((hours - hours.floor()) * 60 -
                  ((hours - hours.floor()) * 60).round()) *
              60)
          .round(),
    );
  }

  static void dispose() {
    _timer?.cancel();
  }
}

class DashboardScreen extends StatefulWidget {
  final String nickname;
  final String birthDate;
  final String birthPlace;

  DashboardScreen({
    this.nickname = '',
    this.birthDate = '',
    this.birthPlace = '',
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  UserState userState = UserState();
  bool _taskCompleted = false;
  int _currentTaskIndex = 0;

  // Kontrolery animacji
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _xpBarController;
  late Animation<double> _xpBarAnimation;
  late AnimationController _auraBarController;
  late Animation<double> _auraBarAnimation;
  late AnimationController _cardAnimationController;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardRotationAnimation;
  late Animation<double> _cardScaleAnimation;

  // Kontrolery animacji dla pasków żywiołów
  late Map<String, AnimationController> _elementalBarControllers;
  late Map<String, Animation<double>> _elementalBarAnimations;

  double _previousXpBarValue = 0.0;
  double _previousAuraValue = 0.0;
  Map<String, double> _previousElementalValues = {};

  // Kontrolery tekstów
  final TextEditingController _reflectionController = TextEditingController();
  final TextEditingController _gratitudeController = TextEditingController();

  Timer? _auraUpdateTimer;

  @override
  void initState() {
    super.initState();

    // Inicjalizacja AuraManager
    AuraManager.initTimer();

    // Timer do aktualizacji UI co minutę
    _auraUpdateTimer = Timer.periodic(Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });

    // Animacja dla efektu awansu
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Animacja dla karty zadania
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _cardSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _cardRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _cardScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    // Animacja dla paska XP
    _xpBarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _xpBarAnimation =
        Tween<double>(begin: userState.expBar, end: userState.expBar).animate(
      CurvedAnimation(parent: _xpBarController, curve: Curves.easeOut),
    );

    // Animacja dla paska Aury
    _auraBarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _auraBarAnimation = Tween<double>(
            begin: AuraManager.aura / 100.0, end: AuraManager.aura / 100.0)
        .animate(
      CurvedAnimation(parent: _auraBarController, curve: Curves.easeOut),
    );

    // Inicjalizacja kontrolerów animacji dla pasków żywiołów
    _elementalBarControllers = {};
    _elementalBarAnimations = {};
    for (String element in ElementalEnergy.energies.keys) {
      _elementalBarControllers[element] = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      _elementalBarAnimations[element] = Tween<double>(
        begin: ElementalEnergy.energies[element]! /
            ElementalEnergy.maxEnergyPerDay,
        end: ElementalEnergy.energies[element]! /
            ElementalEnergy.maxEnergyPerDay,
      ).animate(
        CurvedAnimation(
            parent: _elementalBarControllers[element]!, curve: Curves.easeOut),
      );
      _previousElementalValues[element] = ElementalEnergy.energies[element]!;
    }

    // Uruchom animacje początkowe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProgressBars();
    });
  }

  void _refreshProgressBars() {
    // Odśwież pasek XP
    _xpBarAnimation = Tween<double>(
      begin: 0.0,
      end: userState.expBar,
    ).animate(CurvedAnimation(parent: _xpBarController, curve: Curves.easeOut));
    _xpBarController.forward(from: 0.0);

    // Odśwież pasek Aury
    _auraBarAnimation = Tween<double>(
      begin: 0.0,
      end: AuraManager.aura / 100.0,
    ).animate(
        CurvedAnimation(parent: _auraBarController, curve: Curves.easeOut));
    _auraBarController.forward(from: 0.0);

    // Odśwież paski żywiołów
    for (String element in ElementalEnergy.energies.keys) {
      _elementalBarAnimations[element] = Tween<double>(
        begin: 0.0,
        end: ElementalEnergy.energies[element]! /
            ElementalEnergy.maxEnergyPerDay,
      ).animate(CurvedAnimation(
          parent: _elementalBarControllers[element]!, curve: Curves.easeOut));
      _elementalBarControllers[element]!.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _xpBarController.dispose();
    _auraBarController.dispose();
    _cardAnimationController.dispose();
    _reflectionController.dispose();
    _gratitudeController.dispose();
    _auraUpdateTimer?.cancel();

    for (var controller in _elementalBarControllers.values) {
      controller.dispose();
    }

    AuraManager.dispose();
    super.dispose();
  }

  SpiritualTask get _currentTask => TaskManager.allTasks[_currentTaskIndex];

  String getDailyReflection() {
    DateTime today = DateTime.now();
    int dayOfWeek = today.weekday;
    List<String> reflections = [
      "Mars w Strzelcu: Działaj odważnie i podążaj za swoimi marzeniami.",
      "Księżyc w Raku: Skup się na introspekcji i dbaj o swoje emocje.",
      "Merkury w Bliźniętach: Wyrażaj swoje myśli z jasnością i ciekawością.",
      "Wenus w Wadze: Szukaj harmonii w relacjach i celebruj piękno.",
      "Jowisz w Rybach: Otwórz się na rozwój duchowy i nowe możliwości.",
      "Saturn w Koziorożcu: Buduj swoje cele z cierpliwością i determinacją.",
      "Słońce w Lwie: Świeć jasno i inspiruj innych swoją autentycznością.",
    ];
    return reflections[dayOfWeek - 1];
  }

  void _showLevelUpEffect(String title) {
    _animationController.forward(from: 0.0);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6B46C1), Color(0xFFD4AF37)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 3),
              ),
              child: Stack(
                children: [
                  // Efekt fajerwerków
                  Positioned(
                    top: -50,
                    left: -50,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -50,
                    right: -50,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 700),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: -50,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    right: -50,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Gratulacje!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cinzel',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Awansowałeś na nowy poziom: $title!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD4AF37),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _animationController.reset();
                        },
                        child: Text('Kontynuuj',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToAstrology() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyTransitsScreen(),
      ),
    );
  }

  void _navigateToCompletedTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletedTasksScreen(),
      ),
    );
  }

  void _navigateToTasks() {
    // Nawigacja do ekranu zadań przez główną nawigację
    // Ta funkcja będzie wywołana przez MainScreen
  }

  void _nextTask() {
    _cardSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _cardAnimationController.forward().then((_) {
      setState(() {
        _currentTaskIndex =
            (_currentTaskIndex + 1) % TaskManager.allTasks.length;
      });

      // Animacja wejścia z lewej strony
      _cardSlideAnimation = Tween<Offset>(
        begin: Offset(-1.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ));

      _cardAnimationController.reverse();
    });
  }

  void _previousTask() {
    _cardSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.5, 0),
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _cardAnimationController.forward().then((_) {
      setState(() {
        _currentTaskIndex =
            (_currentTaskIndex - 1 + TaskManager.allTasks.length) %
                TaskManager.allTasks.length;
      });

      // Animacja wejścia z prawej strony
      _cardSlideAnimation = Tween<Offset>(
        begin: Offset(1.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ));

      _cardAnimationController.reverse();
    });
  }

  void _rejectTask() {
    // Animacja rozpadu - karta spada w dół z obrotem
    _cardSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 2.0),
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeIn,
    ));

    _cardRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeIn,
    ));

    _cardAnimationController.forward().then((_) {
      setState(() {
        _currentTaskIndex =
            (_currentTaskIndex + 1) % TaskManager.allTasks.length;
      });
      _cardAnimationController.reset();
    });

    MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Zadanie odrzucone! Nowe zadanie załadowane.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _completeDailyTask() {
    if (_taskCompleted) return;

    // Sprawdź czy mamy wystarczająco aury
    if (AuraManager.aura < AuraManager.auraDropPerTask) {
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Niewystarczająca aura! Poczekaj na regenerację.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Animacja zatwierdzenia - karta unosi się w górę ze świeceniem
    _cardSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -2.0),
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOut,
    ));

    _cardScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOut,
    ));

    _cardAnimationController.forward().then((_) {
      setState(() {
        _taskCompleted = true;
        _previousAuraValue = AuraManager.aura / 100.0;
        _previousXpBarValue = userState.expBar;

        // Zapisz poprzednie wartości energii żywiołów
        for (String element in ElementalEnergy.energies.keys) {
          _previousElementalValues[element] =
              ElementalEnergy.energies[element]!;
        }

        // Dodaj zadanie do listy wykonanych
        CompletedTasksManager.addCompletedTask(_currentTask);

        // Zużyj aurę
        AuraManager.consumeAura();

        // Dodaj energię żywiołu z aktualnego zadania
        ElementalEnergy.addEnergy(
            _currentTask.element, _currentTask.elementalEnergy);

        bool levelUp = userState.completeTask(_currentTask.xpReward, 0);

        // Animacja paska Aury
        _auraBarAnimation = Tween<double>(
          begin: _previousAuraValue,
          end: AuraManager.aura / 100.0,
        ).animate(
          CurvedAnimation(parent: _auraBarController, curve: Curves.easeOut),
        );
        _auraBarController.forward(from: 0.0);

        // Animacja paska XP
        _xpBarAnimation = Tween<double>(
          begin: _previousXpBarValue,
          end: userState.expBar,
        ).animate(
          CurvedAnimation(parent: _xpBarController, curve: Curves.easeOut),
        );
        _xpBarController.forward(from: 0.0);

        // Animacja paska żywiołu
        String element = _currentTask.element;
        _elementalBarAnimations[element] = Tween<double>(
          begin: _previousElementalValues[element]! /
              ElementalEnergy.maxEnergyPerDay,
          end: ElementalEnergy.energies[element]! /
              ElementalEnergy.maxEnergyPerDay,
        ).animate(
          CurvedAnimation(
              parent: _elementalBarControllers[element]!,
              curve: Curves.easeOut),
        );
        _elementalBarControllers[element]!.forward(from: 0.0);

        if (levelUp) {
          _showLevelUpEffect(userState.title);
        }

        // Po kilku sekundach pokazanie nowego zadania
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _taskCompleted = false;
              _currentTaskIndex =
                  (_currentTaskIndex + 1) % TaskManager.allTasks.length;
            });
            _cardAnimationController.reset();
            MyApp.scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
            MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(
                content: Text('Nowe zadanie dnia dostępne!'),
                backgroundColor: Color(0xFFD4AF37),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      });
    });

    MyApp.scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
            'Zadanie wykonane! Otrzymano +${_currentTask.xpReward} XP i +${_currentTask.elementalEnergy.round()} ${_currentTask.element}'),
        backgroundColor: Color(0xFFD4AF37),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _addReflection() {
    if (_reflectionController.text.isNotEmpty) {
      ReflectionJournal.addEntry(_reflectionController.text, 'reflection');
      userState.completeTask(10, 0);
      _reflectionController.clear();

      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Refleksja dodana! Otrzymano +10 XP'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {});
    }
  }

  void _addGratitude() {
    if (_gratitudeController.text.isNotEmpty) {
      ReflectionJournal.addEntry(_gratitudeController.text, 'gratitude');
      userState.completeTask(10, 0);
      _gratitudeController.clear();

      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Wdzięczność dodana! Otrzymano +10 XP'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {});
    }
  }

  Widget _buildElementalEnergyBar(String element) {
    return Column(
      children: [
        Icon(
          ElementalEnergy.getElementIcon(element),
          color: ElementalEnergy.getElementColor(element),
          size: 24,
        ),
        SizedBox(height: 6),
        Container(
          width: 24,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: ElementalEnergy.getElementColor(element), width: 2),
          ),
          child: AnimatedBuilder(
            animation: _elementalBarAnimations[element]!,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: 90 * _elementalBarAnimations[element]!.value,
                    decoration: BoxDecoration(
                      color: ElementalEnergy.getElementColor(element)
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 6),
        Text(
          '${ElementalEnergy.energies[element]!.round()}',
          style: TextStyle(
            color: ElementalEnergy.getElementColor(element),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Aktualizuj aurę przed renderowaniem
    AuraManager.updateAura();
    final timeToFull = AuraManager.timeToFull();
    final todayCompletedTasks = CompletedTasksManager.getTodayCompletedCount();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50), // Przestrzeń na status bar
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sekcja Awatara i Poziomu z paskiem XP
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6B46C1), Color(0xFF34495E)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.amber, width: 2),
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/avatar_placeholder.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.nickname.isNotEmpty
                                      ? widget.nickname
                                      : userState.title,
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cinzel',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Poziom ${userState.level}',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 18),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AnimatedBuilder(
                                            animation: _xpBarAnimation,
                                            builder: (context, child) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: LinearProgressIndicator(
                                                  value: _xpBarAnimation.value,
                                                  minHeight: 6,
                                                  backgroundColor:
                                                      Colors.grey.shade700,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.blueAccent),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(height: 4),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              'XP: ${userState.xp}/${userState.level == 10 ? "MAX" : UserState.levelThresholds[userState.level]}',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Pasek Aury z regeneracją i tłem
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF2C3E50).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.amber.withOpacity(0.3), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aura Dnia',
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          AnimatedBuilder(
                            animation: _auraBarAnimation,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _auraBarAnimation.value,
                                minHeight: 12,
                                backgroundColor: Colors.grey.shade700,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFD4AF37)),
                                borderRadius: BorderRadius.circular(6),
                              );
                            },
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Energia Duchowa: ${AuraManager.aura.round()}/100',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          if (AuraManager.aura < AuraManager.maxAura)
                            Text(
                              'Do pełnej regeneracji: ${timeToFull.inHours}h ${timeToFull.inMinutes % 60}min ${timeToFull.inSeconds % 60}s',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Paski Energii Żywiołów z przezroczystym tłem
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF2C3E50).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.amber.withOpacity(0.3), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Energie Żywiołów',
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: ElementalEnergy.energies.keys
                                .map((element) =>
                                    _buildElementalEnergyBar(element))
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Zadanie Dnia - bez tytułu, tylko nawigacja i karta
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Nawigacja strzałkami
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _previousTask,
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.amber, size: 20),
                                padding: EdgeInsets.all(4),
                              ),
                              Text(
                                '${_currentTaskIndex + 1} / ${TaskManager.allTasks.length}',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              IconButton(
                                onPressed: _nextTask,
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: Colors.amber, size: 20),
                                padding: EdgeInsets.all(4),
                              ),
                            ],
                          ),

                          // Karta zadania z nowymi animacjami
                          AnimatedBuilder(
                            animation: _cardAnimationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: _cardSlideAnimation.value,
                                child: Transform.rotate(
                                  angle: _cardRotationAnimation.value,
                                  child: Transform.scale(
                                    scale: _cardScaleAnimation.value,
                                    child: Card(
                                      color: Color(0xFF2C3E50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            // Główna zawartość zadania
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _currentTask.title,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    _currentTask.description,
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'Nagroda: +${_currentTask.xpReward} XP, +${_currentTask.elementalEnergy.round()} ${_currentTask.element}',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.greenAccent,
                                                        fontSize: 12),
                                                  ),
                                                  SizedBox(height: 16),

                                                  // Przyciski równo rozmieszczone
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                          ),
                                                          onPressed:
                                                              _taskCompleted
                                                                  ? null
                                                                  : _rejectTask,
                                                          child: Text('Odrzuć',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xFFD4AF37),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                          ),
                                                          onPressed: _taskCompleted
                                                              ? null
                                                              : _completeDailyTask,
                                                          child: Text(
                                                              _taskCompleted
                                                                  ? 'Wykonano'
                                                                  : 'Wykonaj',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: 16),

                                            // Większy symbol żywiołu po prawej stronie
                                            Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: ElementalEnergy
                                                        .getElementColor(
                                                            _currentTask
                                                                .element)
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: ElementalEnergy
                                                      .getElementColor(
                                                          _currentTask.element),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    ElementalEnergy
                                                        .getElementIcon(
                                                            _currentTask
                                                                .element),
                                                    color: ElementalEnergy
                                                        .getElementColor(
                                                            _currentTask
                                                                .element),
                                                    size: 40,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    _currentTask.element,
                                                    style: TextStyle(
                                                      color: ElementalEnergy
                                                          .getElementColor(
                                                              _currentTask
                                                                  .element),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 12),

                          // Przycisk "Wyświetl wszystkie zadania"
// Przycisk przekierowujący na ekran zadań
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD4AF37),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            onPressed: () {
                              // Przekierowanie na ekran zadań przez główną nawigację
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TasksScreen()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.list_alt, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  'Wyświetl wszystkie zadania',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Dzisiejsze Statystyki
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Dzisiejsze Statystyki',
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatCard(
                              icon: Icons.star,
                              label: 'Punkty XP',
                              value: '${userState.xp}'),
                          GestureDetector(
                            onTap: _navigateToCompletedTasks,
                            child: StatCard(
                                icon: Icons.task_alt,
                                label: 'Zadania dziś',
                                value: '$todayCompletedTasks'),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Wskazówki Astrologiczne z przyciskiem pod informacją
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Color(0xFF2C3E50).withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wskazówka Astrologiczna',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Księżyc w Skorpionie – dziś skup się na introspekcji.',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 12),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  onPressed: _navigateToAstrology,
                                  child: Text('Dowiedz się więcej',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Sekcja: Daily Reflection z możliwością dodawania
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Color(0xFF2C3E50).withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Codzienna Refleksja',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                getDailyReflection(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 16),

                              // Dodawanie własnej refleksji
                              TextField(
                                controller: _reflectionController,
                                decoration: InputDecoration(
                                  labelText: 'Dodaj własną refleksję',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFF34495E),
                                ),
                                style: TextStyle(color: Colors.white),
                                maxLines: 2,
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _addReflection,
                                child: Text('Dodaj refleksję (+10 XP)',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(height: 16),

                              // Dodawanie wdzięczności
                              TextField(
                                controller: _gratitudeController,
                                decoration: InputDecoration(
                                  labelText: 'Za co jesteś dziś wdzięczny?',
                                  labelStyle: TextStyle(color: Colors.green),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFF34495E),
                                ),
                                style: TextStyle(color: Colors.white),
                                maxLines: 2,
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: _addGratitude,
                                child: Text('Dodaj wdzięczność (+10 XP)',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ekran dla listy wykonanych zadań
class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final completedTasks = CompletedTasksManager.completedTasks;
    final todayTasks = completedTasks.where((task) {
      final today = DateTime.now();
      return task.completedAt.year == today.year &&
          task.completedAt.month == today.month &&
          task.completedAt.day == today.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wykonane Zadania',
          style: TextStyle(
              fontFamily: 'Cinzel', color: Colors.amber, fontSize: 22),
        ),
        backgroundColor: Color(0xFF1E293B),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Color(0xFF1E293B),
      body: todayTasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, color: Colors.amber, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Brak wykonanych zadań dzisiaj',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Wróć do dashboardu i wykonaj swoje pierwsze zadanie!',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: todayTasks.length,
              itemBuilder: (context, index) {
                final task = todayTasks[index];
                return Card(
                  color: Color(0xFF2C3E50),
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ElementalEnergy.getElementColor(task.element)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ElementalEnergy.getElementColor(task.element),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        ElementalEnergy.getElementIcon(task.element),
                        color: ElementalEnergy.getElementColor(task.element),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nagroda: +${task.xpReward} XP, +${task.elementalEnergy.round()} ${task.element}',
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 12),
                        ),
                        Text(
                          'Wykonano: ${task.completedAt.hour.toString().padLeft(2, '0')}:${task.completedAt.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}

// Ekran dla tranzyty dnia (astrologia)
class DailyTransitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tranzyty Dnia',
            style: TextStyle(fontFamily: 'Cinzel', color: Colors.amber)),
        backgroundColor: Color(0xFF1E293B),
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Color(0xFF1E293B),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dzisiejsze Tranzyty Planetarne',
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildTransitInfo('Koniunkcja Księżyca i Jowisza',
                'Sprzyja rozwojowi duchowemu, optymizmowi i hojności. Dobry czas na naukę i podróże mentalne.'),
            SizedBox(height: 12),
            _buildTransitInfo('Słońce w kwadraturze do Saturna',
                'Może przynieść poczucie ograniczenia i frustracji. Ważna jest cierpliwość i systematyczna praca nad celami.'),
            SizedBox(height: 12),
            _buildTransitInfo('Pełnia Księżyca (za 3 dni)',
                'Energia osiąga swój szczyt. Czas na podsumowania, uwalnianie tego, co już nie służy i manifestację intencji.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitInfo(String title, String description) {
    return Card(
      color: Color(0xFF2C3E50),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(description,
                style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatCard(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF34495E).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 24),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text(value,
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
