import 'package:flutter/material.dart';
import 'manual_weight_dashboard_page.dart';
import 'weight_input_page.dart';

void main() {
  runApp(const PaddockProApp());
}

class PaddockProApp extends StatelessWidget {
  const PaddockProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paddock Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFF5F00),
        scaffoldBackgroundColor: const Color(0xFF131313),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ManualWeightDashboardPage(),
    const WeightInputPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF201F1F),
        selectedItemColor: const Color(0xFFFF5F00),
        unselectedItemColor: const Color(0xFFE4BFB1).withOpacity(0.5),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Manual Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            activeIcon: Icon(Icons.edit_note),
            label: 'Weight Input',
          ),
        ],
      ),
    );
  }
}
