import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../main.dart';
import '../user_state.dart';
import 'dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Alias dla zgodności
typedef SpiritualTask = SpiritualTaskModel;

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  String _selectedTimeFilter = 'Dzienne';
  String? _selectedElementFilter;
  late UserState? userState;
  late AnimationController _completionAnimationController;
  late Animation<double> _completionAnimation;
  Set<int> _completedTaskIndices = {};
  List<SpiritualTaskModel> _availableTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserState>(context, listen: false);

    _completionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _completionAnimation = CurvedAnimation(
      parent: _completionAnimationController,
      curve: Curves.elasticOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500));
      didChangeDependencies();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userState == null) {
      userState = Provider.of<UserState>(context, listen: false);
      _loadTasks();
    }
  }

  Future<void> _loadTasks() async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('Rozpoczynam ładowanie zadań...');

      // Sprawdź połączenie z Firebase
      await _checkFirebaseData();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('globalTasks')
          .where('isActive', isEqualTo: true)
          .get();

      print('Pobrano ${snapshot.docs.length} zadań z Firebase');

      if (snapshot.docs.isEmpty) {
        print('Brak aktywnych zadań - używam zadań domyślnych');
        _availableTasks = _getDefaultTasks();
      } else {
        _availableTasks = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return SpiritualTaskModel(
            id: doc.id,
            title: data['title'] ?? 'Brak tytułu',
            description: data['description'] ?? 'Brak opisu',
            xpReward: data['xpReward'] ?? 10,
            element: data['element'] ?? 'Ziemia',
            elementalEnergy: (data['elementalEnergy'] is int)
                ? (data['elementalEnergy'] as int).toDouble()
                : (data['elementalEnergy'] as double? ?? 10.0),
            category: data['category'] ?? 'Ogólne',
            isCustom: data['isCustom'] ?? false,
            createdBy: data['createdBy'],
            createdAt: data['createdAt'] != null
                ? (data['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
          );
        }).toList();
      }

      print('Załadowano ${_availableTasks.length} zadań');

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Błąd ładowania zadań: $e');
      setState(() {
        _isLoading = false;
        _availableTasks = _getDefaultTasks(); // Fallback na zadania domyślne
      });
    }
  }

// Zadania domyślne jako fallback
  List<SpiritualTaskModel> _getDefaultTasks() {
    return [
      SpiritualTaskModel(
        id: 'default_1',
        title: 'Spacer w Naturze',
        description: 'Idź na 15-minutowy spacer do parku lub lasu',
        xpReward: 30,
        element: 'Ziemia',
        elementalEnergy: 20.0,
        category: 'Uziemienie',
        isCustom: false,
        createdAt: DateTime.now(),
      ),
      SpiritualTaskModel(
        id: 'default_2',
        title: 'Medytacja Oddechowa',
        description: 'Wykonaj 10-minutową medytację oddechową',
        xpReward: 25,
        element: 'Powietrze',
        elementalEnergy: 15.0,
        category: 'Intuicja',
        isCustom: false,
        createdAt: DateTime.now(),
      ),
      SpiritualTaskModel(
        id: 'default_3',
        title: 'Dziennik Wdzięczności',
        description: 'Zapisz 3 rzeczy, za które jesteś wdzięczny',
        xpReward: 20,
        element: 'Woda',
        elementalEnergy: 12.0,
        category: 'Spokój',
        isCustom: false,
        createdAt: DateTime.now(),
      ),
      SpiritualTaskModel(
        id: 'default_4',
        title: 'Kreatywne Wyrażenie',
        description: 'Narysuj lub napisz coś kreatywnego przez 15 minut',
        xpReward: 28,
        element: 'Ogień',
        elementalEnergy: 16.0,
        category: 'Inspiracja',
        isCustom: false,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  void dispose() {
    _completionAnimationController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6B46C1), Color(0xFF34495E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Zadania',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cinzel',
            ),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await _loadTasks();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Zadania odświeżone!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(Icons.refresh, color: Colors.amber),
                          tooltip: 'Odśwież zadania',
                        ),
                        Text('XP',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 9)),
                        LinearProgressIndicator(
                          value: userState?.expBar,
                          minHeight: 5,
                          backgroundColor: Colors.grey.shade700,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Aura',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 9)),
                        LinearProgressIndicator(
                          value: userState!.aura / 100.0,
                          minHeight: 5,
                          backgroundColor: Colors.grey.shade700,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                backgroundColor: Colors.amber.withOpacity(0.3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Kategorie',
            style: TextStyle(
                color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Dzienne', 'Tygodniowe', 'Specjalne'].map((filter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: ChoiceChip(
                    label: Text(filter, style: TextStyle(fontSize: 12)),
                    selected: _selectedTimeFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTimeFilter = filter;
                      });
                    },
                    backgroundColor: Color(0xFF2C3E50),
                    selectedColor: Colors.amber,
                    labelStyle: TextStyle(
                      color: _selectedTimeFilter == filter
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Żywioły',
            style: TextStyle(
                color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedElementFilter = null;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedElementFilter == null
                        ? Colors.amber
                        : Color(0xFF2C3E50),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Icon(
                    Icons.all_inclusive,
                    color: _selectedElementFilter == null
                        ? Colors.black
                        : Colors.amber,
                    size: 24,
                  ),
                ),
              ),
              ...ElementalEnergy.energies.keys.map((element) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedElementFilter =
                          _selectedElementFilter == element ? null : element;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedElementFilter == element
                          ? ElementalEnergy.getElementColor(element)
                          : Color(0xFF2C3E50),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ElementalEnergy.getElementColor(element),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      ElementalEnergy.getElementIcon(element),
                      color: _selectedElementFilter == element
                          ? Colors.black
                          : ElementalEnergy.getElementColor(element),
                      size: 24,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  void _completeTask(SpiritualTaskModel task, int index) async {
    if (userState!.aura < (100.0 / 15.0)) {
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
      _completedTaskIndices.add(index);
    });

    try {
      // Zapisz ukończone zadanie do Firebase
      await userState!.addCompletedTaskFromModel(task);

      // Zużyj aurę
      await userState!.consumeAura(100.0 / 15.0);

      // Ukończ zadanie z pełnym zapisem do Firebase
      await userState!.completeTask(
        task.xpReward,
        0,
        task.element,
        task.elementalEnergy,
      );

      _completionAnimationController.forward().then((_) {
        _completionAnimationController.reverse();
      });

      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
              'Zadanie wykonane! Otrzymano +${task.xpReward} XP i +${task.elementalEnergy.round()} ${task.element}'),
          backgroundColor: Color(0xFFD4AF37),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Błąd wykonywania zadania: $e');
      setState(() {
        _completedTaskIndices.remove(index);
      });
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Wystąpił błąd podczas wykonywania zadania'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddTaskDialog() {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    String element = 'Ziemia';
    int xp = 20;
    double energy = 10;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Color(0xFF2C3E50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(
                'Dodaj własne zadanie',
                style: TextStyle(color: Colors.amber, fontFamily: 'Cinzel'),
              ),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Tytuł zadania',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.amber.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Color(0xFF34495E),
                        ),
                        style: TextStyle(color: Colors.white),
                        onSaved: (value) => title = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Wprowadź tytuł' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Opis zadania',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.amber.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Color(0xFF34495E),
                        ),
                        style: TextStyle(color: Colors.white),
                        maxLines: 3,
                        onSaved: (value) => description = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'Wprowadź opis' : null,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: element,
                        decoration: InputDecoration(
                          labelText: 'Żywioł',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.amber.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Color(0xFF34495E),
                        ),
                        dropdownColor: Color(0xFF34495E),
                        style: TextStyle(color: Colors.white),
                        items:
                            ElementalEnergy.energies.keys.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(
                                  ElementalEnergy.getElementIcon(value),
                                  color: ElementalEnergy.getElementColor(value),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setDialogState(() {
                            element = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: xp.toString(),
                              decoration: InputDecoration(
                                labelText: 'Punkty XP',
                                labelStyle: TextStyle(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Color(0xFF34495E),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              onSaved: (value) =>
                                  xp = int.tryParse(value!) ?? 20,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: energy.toString(),
                              decoration: InputDecoration(
                                labelText: 'Energia żywiołu',
                                labelStyle: TextStyle(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Color(0xFF34495E),
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              onSaved: (value) =>
                                  energy = double.tryParse(value!) ?? 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child:
                      Text('Anuluj', style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4AF37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Dodaj zadanie do Firebase
                      try {
                        await FirebaseFirestore.instance
                            .collection('globalTasks')
                            .add({
                          'title': title,
                          'description': description,
                          'xpReward': xp,
                          'element': element,
                          'elementalEnergy': energy,
                          'category': 'Własne',
                          'isCustom': true,
                          'createdBy': userState!.currentUser?.id,
                          'createdAt': FieldValue.serverTimestamp(),
                          'isActive': true,
                        });

                        // Odśwież listę zadań
                        await _loadTasks();

                        Navigator.of(context).pop();
                        MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(
                            content: Text('Nowe zadanie dodane!'),
                            backgroundColor: Color(0xFFD4AF37),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        print('Błąd dodawania zadania: $e');
                        MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(
                            content: Text('Błąd podczas dodawania zadania'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Dodaj', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _availableTasks.where((task) {
      if (_selectedElementFilter != null &&
          task.element != _selectedElementFilter) {
        return false;
      }
      return true;
    }).toList();

    return Consumer<UserState>(
      builder: (context, userState, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildFilters(),
                  Expanded(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.amber),
                            ),
                          )
                        : filteredTasks.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.task_alt,
                                        color: Colors.amber, size: 64),
                                    SizedBox(height: 16),
                                    Text(
                                      'Brak zadań do wyświetlenia',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 18),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Dodaj własne zadanie lub zmień filtry',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 14),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                itemCount: filteredTasks.length,
                                itemBuilder: (context, index) {
                                  final task = filteredTasks[index];
                                  final isCompleted =
                                      _completedTaskIndices.contains(index);

                                  return AnimatedBuilder(
                                    animation: _completionAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: isCompleted
                                            ? 1.0 +
                                                (_completionAnimation.value *
                                                    0.1)
                                            : 1.0,
                                        child: Card(
                                          color: isCompleted
                                              ? Colors.green.withOpacity(0.3)
                                              : Color(0xFF2C3E50)
                                                  .withOpacity(0.9),
                                          margin: EdgeInsets.only(bottom: 12),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: ListTile(
                                            leading: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: ElementalEnergy
                                                        .getElementColor(
                                                            task.element)
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: ElementalEnergy
                                                      .getElementColor(
                                                          task.element),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Icon(
                                                ElementalEnergy.getElementIcon(
                                                    task.element),
                                                color: ElementalEnergy
                                                    .getElementColor(
                                                        task.element),
                                                size: 30,
                                              ),
                                            ),
                                            title: Text(
                                              task.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration: isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.description,
                                                  style: TextStyle(
                                                      color: Colors.white70),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Nagroda: +${task.xpReward} XP, +${task.elementalEnergy.round()} ${task.element}',
                                                  style: TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  'Kategoria: ${task.category}',
                                                  style: TextStyle(
                                                      color: Colors.amber,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            trailing: isCompleted
                                                ? Icon(Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 30)
                                                : ElevatedButton(
                                                    onPressed: () =>
                                                        _completeTask(
                                                            task, index),
                                                    child: Text('Wykonaj'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xFFD4AF37),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddTaskDialog,
            icon: Icon(Icons.add, color: Colors.black),
            label: Text('Dodaj zadanie', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.amber,
          ),
        );
      },
    );
  }

  Future<void> _checkFirebaseData() async {
    try {
      // Sprawdź czy są jakiekolwiek zadania w globalTasks
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('globalTasks')
          .limit(1)
          .get();

      print('Liczba zadań w bazie: ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        print('Brak zadań w bazie - dodaję zadania...');
        await _addSampleTasksToFirebase();
      }
    } catch (e) {
      print('Błąd sprawdzania Firebase: $e');
    }
  }

// Dodaj przykładowe zadania jeśli baza jest pusta
  Future<void> _addSampleTasksToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('globalTasks').add({
        'title': 'Spacer w Naturze',
        'description': 'Idź na 15-minutowy spacer do parku lub lasu',
        'xpReward': 30,
        'element': 'Ziemia',
        'elementalEnergy': 20.0,
        'category': 'Uziemienie',
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'isCustom': false,
      });

      await FirebaseFirestore.instance.collection('globalTasks').add({
        'title': 'Medytacja',
        'description': 'Medytuj przez 10 minut',
        'xpReward': 25,
        'element': 'Powietrze',
        'elementalEnergy': 15.0,
        'category': 'Intuicja',
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'isCustom': false,
      });

      print('Przykładowe zadania dodane!');
      await _loadTasks(); // Odśwież listę
    } catch (e) {
      print('Błąd dodawania przykładowych zadań: $e');
    }
  }
}
