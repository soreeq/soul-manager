import 'package:flutter/material.dart';
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
        return Colors.green; // Zielona ziemia
      case 'Ogień':
        return Colors.red; // Czerwony ogień
      case 'Woda':
        return Colors.blue; // Niebieski woda
      case 'Powietrze':
        return Colors.white; // Białe powietrze
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
  SpiritualTask _currentTask = TaskManager.getRandomTask();
  int _completedTasksToday = 0; // Licznik wykonanych zadań

  // Kontrolery animacji
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _xpBarController;
  late Animation<double> _xpBarAnimation;
  late AnimationController _auraBarController;
  late Animation<double> _auraBarAnimation;

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
  PageController _taskPageController = PageController();

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

    // Animacja dla paska XP
    _xpBarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _xpBarAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
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
      _elementalBarAnimations[element] =
          Tween<double>(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _elementalBarControllers[element]!, curve: Curves.easeOut),
      );
      _previousElementalValues[element] = ElementalEnergy.energies[element]!;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _xpBarController.dispose();
    _auraBarController.dispose();
    _reflectionController.dispose();
    _gratitudeController.dispose();
    _auraUpdateTimer?.cancel();
    _taskPageController.dispose();

    for (var controller in _elementalBarControllers.values) {
      controller.dispose();
    }

    AuraManager.dispose();
    super.dispose();
  }

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

  void _rejectTask() {
    setState(() {
      _currentTask = TaskManager.getRandomTask();
    });
    MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Nowe zadanie zostało załadowane!'),
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

    setState(() {
      _taskCompleted = true;
      _completedTasksToday++; // Aktualizuj licznik zadań
      _previousAuraValue = AuraManager.aura / 100.0;
      _previousXpBarValue = userState.expBar;

      // Zapisz poprzednie wartości energii żywiołów
      for (String element in ElementalEnergy.energies.keys) {
        _previousElementalValues[element] = ElementalEnergy.energies[element]!;
      }

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
            parent: _elementalBarControllers[element]!, curve: Curves.easeOut),
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
            _currentTask = TaskManager.getRandomTask();
          });
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
          size: 24, // Większe symbole żywiołów
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'), // Tło splash.png
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black
                  .withOpacity(0.3), // Przyciemnij tło dla lepszej czytelności
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text(
                'Dashboard ${userState.title}',
                style: TextStyle(
                    fontFamily: 'Cinzel', color: Colors.amber, fontSize: 22),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sekcja Awatara i Poziomu z paskiem XP
                    Container(
                      margin: EdgeInsets.all(16),
                      padding:
                          EdgeInsets.all(20), // Większy padding od krawędzi
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
                          SizedBox(width: 20), // Większy odstęp
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
                                          color: Colors.white70,
                                          fontSize: 18), // Większa czcionka
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
                                                    horizontal:
                                                        8), // Oddzielenie od krawędzi
                                                child: LinearProgressIndicator(
                                                  value: _xpBarAnimation.value,
                                                  minHeight:
                                                      6, // Mniejszy pasek
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
                                                  fontSize:
                                                      14), // Większa czcionka
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

                    // Pasek Aury z regeneracją
                    Padding(
                      padding: const EdgeInsets.all(16.0),
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
                              'Do pełnej regeneracji: ${timeToFull.inHours}h ${timeToFull.inMinutes % 60}min',
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 12),
                            ),
                        ],
                      ),
                    ),

                    // Paski Energii Żywiołów
                    Padding(
                      padding: const EdgeInsets.all(16.0),
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

                    // Zadanie Dnia z możliwością przesuwania i odrzucania
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Zadanie Dnia',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Wykonane: $_completedTasksToday', // Licznik zadań
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 200,
                            child: PageView(
                              controller: _taskPageController,
                              children: [
                                // Karta zadania z możliwością przesuwania
                                Card(
                                  color: Color(0xFF2C3E50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _currentTask.title,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
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
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
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
                                                    size: 14,
                                                  ),
                                                  SizedBox(width: 4),
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
                                              color: Colors.greenAccent,
                                              fontSize: 12),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                              ),
                                              onPressed: _taskCompleted
                                                  ? null
                                                  : _rejectTask,
                                              child: Text('Odrzuć',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFFD4AF37),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                      color: Colors.black)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              'Przesuń kartę w lewo lub prawo aby zobaczyć więcej opcji',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Szybkie Statystyki
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Szybkie Statystyki',
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
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
                          StatCard(
                              icon: Icons.task_alt,
                              label: 'Zadania',
                              value:
                                  '$_completedTasksToday/15'), // Zaktualizowany licznik
                        ],
                      ),
                    ),

                    // Wskazówki Astrologiczne
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
