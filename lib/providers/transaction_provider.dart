// lib/providers/transaction_provider.dart
import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class TransactionProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final NotificationService _notifications = NotificationService();

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => [..._transactions];

  Future<void> loadTransactions() async {
    _transactions = await _db.getTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final id = await _db.insertTransaction(transaction);
    final newTransaction = transaction.copyWith(id: id);
    _transactions.add(newTransaction);

    if (transaction.isRecurring && transaction.nextDueDate != null) {
      await _notifications.scheduleTransactionReminder(newTransaction);
    }

    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _db.updateTransaction(transaction);

    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
    }

    if (transaction.isRecurring && transaction.nextDueDate != null) {
      await _notifications.scheduleTransactionReminder(transaction);
    }

    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await _db.deleteTransaction(id);
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }

  Future<List<Transaction>> getTransactionsByDateRange(
      DateTime start, DateTime end) async {
    return await _db.getTransactionsByDateRange(start, end);
  }

  double getTotalIncome(DateTime start, DateTime end) {
    return _transactions
        .where((t) => !t.isExpense &&
        t.date.isAfter(start.subtract(const Duration(days: 1))) &&
        t.date.isBefore(end.add(const Duration(days: 1))))
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getTotalExpense(DateTime start, DateTime end) {
    return _transactions
        .where((t) => t.isExpense &&
        t.date.isAfter(start.subtract(const Duration(days: 1))) &&
        t.date.isBefore(end.add(const Duration(days: 1))))
        .fold(0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getExpensesByCategory(DateTime start, DateTime end) {
    final Map<String, double> result = {};

    for (var transaction in _transactions) {
      if (transaction.isExpense &&
          transaction.date.isAfter(start.subtract(const Duration(days: 1))) &&
          transaction.date.isBefore(end.add(const Duration(days: 1)))) {

        if (result.containsKey(transaction.categoryId)) {
          result[transaction.categoryId] =
              result[transaction.categoryId]! + transaction.amount;
        } else {
          result[transaction.categoryId] = transaction.amount;
        }
      }
    }

    return result;
  }
}