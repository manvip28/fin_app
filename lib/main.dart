import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/category_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/category_management_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart'; // Import auth screen
import 'services/notification_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Notifications
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()..loadCategories()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()..loadTransactions()),
      ],
      child: MaterialApp(
        title: 'MyFinance',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthScreen(), // Set AuthScreen as the first screen
        routes: {
          '/home': (context) => HomeScreen(displayName: 'Guest'),
          '/auth': (context) => const AuthScreen(),
        },
      ),
    );
  }
}