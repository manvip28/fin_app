// lib/models/transaction.dart
import 'package:flutter/foundation.dart';

class Transaction {
  final String? id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final String categoryId;
  final bool isRecurring;
  final String? recurrencePattern; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime? nextDueDate;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.categoryId,
    this.isRecurring = false,
    this.recurrencePattern,
    this.nextDueDate,
  });

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    bool? isExpense,
    String? categoryId,
    bool? isRecurring,
    String? recurrencePattern,
    DateTime? nextDueDate,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isExpense: isExpense ?? this.isExpense,
      categoryId: categoryId ?? this.categoryId,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      nextDueDate: nextDueDate ?? this.nextDueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'isExpense': isExpense ? 1 : 0,
      'categoryId': categoryId,
      'isRecurring': isRecurring ? 1 : 0,
      'recurrencePattern': recurrencePattern,
      'nextDueDate': nextDueDate?.millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      isExpense: map['isExpense'] == 1,
      categoryId: map['categoryId'],
      isRecurring: map['isRecurring'] == 1,
      recurrencePattern: map['recurrencePattern'],
      nextDueDate: map['nextDueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextDueDate'])
          : null,
    );
  }
}