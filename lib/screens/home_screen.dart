import 'package:fin_app/screens/profile_screen.dart';
import 'package:fin_app/screens/transaction_list_screen.dart';
import 'package:flutter/material.dart';

import 'category_management_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final String displayName;

  const HomeScreen({Key? key, required this.displayName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of screens to navigate between, passing displayName to ProfileScreen
    final List<Widget> screens = [
      const DashboardScreen(),
      const TransactionListScreen(),
      const CategoryManagementScreen(),
      ProfileScreen(displayName: widget.displayName),
    ];

    return Scaffold(
      body: SafeArea(
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
