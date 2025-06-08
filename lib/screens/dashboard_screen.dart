import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../main.dart';
import '../user_state.dart';

class ElementalEnergy {
  static Map<String, double> energies = {
    'fire': 0.0, // Ogień
    'water': 0.0, // Woda
    'earth': 0.0, // Ziemia
    'air': 0.0, // Powietrze
  };

  static const double maxEnergy = 100.0;

  static void addEnergy(String element, double amount) {
    if (energies.containsKey(element)) {
      energies[element] = (energies[element]! + amount).clamp(0.0, maxEnergy);
    }
  }

  static void resetDaily() {
    energies.forEach((key, value) {
      energies[key] = 0.0;
    });
  }
}

class SpiritualTask {
  final String title;
  final String description;
  final int xpReward;
  final String element;
  final double elementReward;
  final String category;

  SpiritualTask({
    required this.title,
    required this.description,
    required this.xpReward,
    required this.element,
    required this.elementReward,
    required this.category,
  });
}

class TaskManager {
  static final List<SpiritualTask> allTasks = [
    // Uziemienie (Energia Ziemi)
    SpiritualTask(
      title: 'Spacer w Naturze',
      description: 'Idź na 15-minutowy spacer do parku lub lasu',
      xpReward: 50,
      element: 'earth',
      elementReward: 25.0,
      category: 'Uziemienie',
    ),
    SpiritualTask(
      title: 'Ćwiczenie Boso',
      description: 'Stań boso na trawie przez 5 minut',
      xpReward: 30,
      element: 'earth',
      elementReward: 20.0,
      category: 'Uziemienie',
    ),
    SpiritualTask(
      title: 'Dbanie o Rośliny',
      description: 'Podlej rośliny w domu lub ogrodzie',
      xpReward: 25,
      element: 'earth',
      elementReward: 15.0,
      category: 'Uziemienie',
    ),

    // Inspiracja (Energia Ognia)
    SpiritualTask(
      title: 'Dziennik Kreatywny',
      description: 'Zapisz 3 pomysły lub myśli bez oceniania',
      xpReward: 40,
      element: 'fire',
      elementReward: 30.0,
      category: 'Inspiracja',
    ),
    SpiritualTask(
      title: 'Rysunek Intuicyjny',
      description: 'Narysuj coś odzwierciedlającego Twój nastrój',
      xpReward: 35,
      element: 'fire',
      elementReward: 25.0,
      category: 'Inspiracja',
    ),
    SpiritualTask(
      title: 'Taniec Wyrażenia',
      description: 'Tańcz przez 5 minut, wyrażając emocje',
      xpReward: 45,
      element: 'fire',
      elementReward: 35.0,
      category: 'Inspiracja',
    ),

    // Spokój (Energia Wody)
    SpiritualTask(
      title: 'Medytacja przy Wodzie',
      description: 'Medytuj przez 10 minut przy wodzie',
      xpReward: 60,
      element: 'water',
      elementReward: 40.0,
      category: 'Spokój',
    ),
    SpiritualTask(
      title: 'Kąpiel Oczyszczająca',
      description: 'Weź kąpiel z solą, wizualizując oczyszczenie',
      xpReward: 35,
      element: 'water',
      elementReward: 25.0,
      category: 'Spokój',
    ),
    SpiritualTask(
      title: 'Wdzięczność za Emocje',
      description:
          'Zapisz 3 rzeczy związane z emocjami, za które jesteś wdzięczny',
      xpReward: 30,
      element: 'water',
      elementReward: 20.0,
      category: 'Spokój',
    ),

    // Intuicja (Energia Powietrza)
    SpiritualTask(
      title: 'Ćwiczenie Oddechowe',
      description: 'Wykonaj 5-minutowe głębokie oddychanie',
      xpReward: 40,
      element: 'air',
      elementReward: 30.0,
      category: 'Intuicja',
    ),
    SpiritualTask(
      title: 'Tarot lub Runy',
      description: 'Wyciągnij kartę tarota i zapisz przesłanie',
      xpReward: 35,
      element: 'air',
      elementReward: 25.0,
      category: 'Intuicja',
    ),
    SpiritualTask(
      title: 'Słuchanie Ciszy',
      description: 'Spędź 5 minut w całkowitej ciszy',
      xpReward: 30,
      element: 'air',
      elementReward: 20.0,
      category: 'Intuicja',
    ),
  ];

  static SpiritualTask getRandomTask() {
    final random = Random();
    return allTasks[random.nextInt(allTasks.length)];
  }
}

class ReflectionEntry {
  final String text;
  final String type;
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

class WaterWavesPainter extends CustomPainter {
  final double animationValue;

  WaterWavesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 2;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height -
          waveHeight *
              sin((x / waveLength * 2 * pi) + (animationValue * 2 * pi));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
  SpiritualTask? _currentTask;

  // Kontrolery animacji
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _xpBarController;
  late Animation<double> _xpBarAnimation;
  late AnimationController _auraBarController;
  late Animation<double> _auraBarAnimation;
  late AnimationController _elementalController;
  late Animation<double> _elementalAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  double _previousXpBarValue = 0.0;
  double _previousAuraValue = 0.0;

  // Kontrolery tekstów
  final TextEditingController _reflectionController = TextEditingController();
  final TextEditingController _gratitudeController = TextEditingController();

  Timer? _auraUpdateTimer;

  @override
  void initState() {
    super.initState();

    // Inicjalizacja zadania
    _currentTask = TaskManager.getRandomTask();

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

    // Animacja dla pasków żywiołów
    _elementalController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _elementalAnimation = CurvedAnimation(
      parent: _elementalController,
      curve: Curves.easeOut,
    );

    // Animacja pojawiania się elementów
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Animacja fal wodnych
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _waveAnimation = CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    );

    // Rozpocznij animację pojawiania się
    _fadeController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _xpBarController.dispose();
    _auraBarController.dispose();
    _elementalController.dispose();
    _fadeController.dispose();
    _waveController.dispose();
    _reflectionController.dispose();
    _gratitudeController.dispose();
    _auraUpdateTimer?.cancel();
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

  void _completeDailyTask() {
    if (_taskCompleted || _currentTask == null) return;

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
      _previousAuraValue = AuraManager.aura / 100.0;
      _previousXpBarValue = userState.expBar;

      // Zużyj aurę
      AuraManager.consumeAura();

      // Dodaj energię żywiołu
      ElementalEnergy.addEnergy(
          _currentTask!.element, _currentTask!.elementReward);

      bool levelUp = userState.completeTask(_currentTask!.xpReward, 0);

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

      // Animacja pasków żywiołów
      _elementalController.forward(from: 0.0);

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
            'Zadanie wykonane! Otrzymano +${_currentTask!.xpReward} XP i +${_currentTask!.elementReward.round()} energii ${_getElementName(_currentTask!.element)}'),
        backgroundColor: Color(0xFFD4AF37),
        duration: Duration(seconds: 3),
      ),
    );
  }

  String _getElementName(String element) {
    switch (element) {
      case 'fire':
        return 'Ognia';
      case 'water':
        return 'Wody';
      case 'earth':
        return 'Ziemi';
      case 'air':
        return 'Powietrza';
      default:
        return element;
    }
  }

  Color _getElementColor(String element) {
    switch (element) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'earth':
        return Colors.brown;
      case 'air':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  IconData _getElementIcon(String element) {
    switch (element) {
      case 'fire':
        return Icons.local_fire_department;
      case 'water':
        return Icons.water_drop;
      case 'earth':
        return Icons.terrain;
      case 'air':
        return Icons.air;
      default:
        return Icons.help;
    }
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

  @override
  Widget build(BuildContext context) {
    AuraManager.updateAura();
    final timeToFull = AuraManager.timeToFull();

    return Scaffold(
      body: Stack(
        children: [
          // Animowane tło z efektem wody
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: WaterWavesPainter(_waveAnimation.value),
                size: Size.infinite,
              );
            },
          ),

          // Gradient overlay dla lepszej czytelności
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E293B).withOpacity(0.9),
                  Color(0xFF1E293B).withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Główna zawartość
          Column(
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
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sekcja Awatara i Poziomu z paskiem XP
                        Container(
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6B46C1), Color(0xFF34495E)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.amber, width: 2),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/avatar_placeholder.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        Text(
                                          'Poziom ${userState.level}',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 8),
                                        // Mały pasek XP obok poziomu
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'XP: ${userState.xp}/${userState.level == 10 ? "MAX" : UserState.levelThresholds[userState.level]}',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(height: 4),
                                            AnimatedBuilder(
                                              animation: _xpBarAnimation,
                                              builder: (context, child) {
                                                return LinearProgressIndicator(
                                                  value: _xpBarAnimation.value,
                                                  minHeight: 8,
                                                  backgroundColor:
                                                      Colors.grey.shade700,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.blueAccent),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Pasek Aury
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFD4AF37)),
                                        borderRadius: BorderRadius.circular(6),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Energia Duchowa: ${AuraManager.aura.round()}/100',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                  if (AuraManager.aura < AuraManager.maxAura)
                                    Text(
                                      'Do pełnej regeneracji: ${timeToFull.inHours}h ${timeToFull.inMinutes % 60}min',
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 12),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Paski Energii Żywiołów
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
                                    'Energie Żywiołów',
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: ElementalEnergy.energies.entries
                                        .map((entry) {
                                      return AnimatedBuilder(
                                        animation: _elementalAnimation,
                                        builder: (context, child) {
                                          return Column(
                                            children: [
                                              Icon(
                                                _getElementIcon(entry.key),
                                                color:
                                                    _getElementColor(entry.key),
                                                size: 24,
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                width: 60,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: _getElementColor(
                                                          entry.key)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: (entry.value /
                                                              ElementalEnergy
                                                                  .maxEnergy) *
                                                          100 *
                                                          _elementalAnimation
                                                              .value,
                                                      decoration: BoxDecoration(
                                                        color: _getElementColor(
                                                                entry.key)
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${entry.value.round()}/100',
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                _getElementName(entry.key),
                                                style: TextStyle(
                                                    color: _getElementColor(
                                                        entry.key),
                                                    fontSize: 10),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Zadanie Dnia (losowe)
                        if (_currentTask != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              color: Color(0xFF2C3E50).withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Zadanie Dnia',
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getElementColor(
                                                    _currentTask!.element)
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: _getElementColor(
                                                    _currentTask!.element)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getElementIcon(
                                                    _currentTask!.element),
                                                color: _getElementColor(
                                                    _currentTask!.element),
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                _currentTask!.category,
                                                style: TextStyle(
                                                  color: _getElementColor(
                                                      _currentTask!.element),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      _currentTask!.title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _currentTask!.description,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Nagroda: +${_currentTask!.xpReward} XP, +${_currentTask!.elementReward.round()} energii ${_getElementName(_currentTask!.element)}',
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 12),
                                    ),
                                    SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFD4AF37),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        onPressed: _taskCompleted
                                            ? null
                                            : _completeDailyTask,
                                        child: Text(
                                            _taskCompleted
                                                ? 'Wykonano'
                                                : 'Wykonaj',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                  value: '3/5'),
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
                                            color:
                                                Colors.blue.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
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
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
                                      labelStyle:
                                          TextStyle(color: Colors.green),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.green.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
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
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
              ),
            ],
          ),
        ],
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
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
