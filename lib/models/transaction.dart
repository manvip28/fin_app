import 'package:flutter/material.dart';

class Transaction {
  final String? id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final String categoryId;
  final bool isRecurring;
  final String? recurrencePattern;
  final DateTime? nextDueDate;
  final bool enableNotification;
  final TimeOfDay? notificationTime;

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
    this.enableNotification = false,
    this.notificationTime,
  });

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
      'enableNotification': enableNotification ? 1 : 0,
      'notificationHour': notificationTime?.hour,
      'notificationMinute': notificationTime?.minute,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    TimeOfDay? notificationTime;
    if (map['notificationHour'] != null && map['notificationMinute'] != null) {
      notificationTime = TimeOfDay(
        hour: map['notificationHour'],
        minute: map['notificationMinute'],
      );
    }

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
      enableNotification: map['enableNotification'] == 1,
      notificationTime: notificationTime,
    );
  }

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
    bool? enableNotification,
    TimeOfDay? notificationTime,
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
      enableNotification: enableNotification ?? this.enableNotification,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }
}