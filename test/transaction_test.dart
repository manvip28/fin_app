import 'package:flutter_test/flutter_test.dart';
import 'package:fin_app/models/transaction.dart';
import 'package:flutter/material.dart';

void main() {
  group('Transaction model tests', () {
    test('Transaction constructor sets values correctly', () {
      final date = DateTime.now();
      final transaction = Transaction(
        title: 'Test Transaction',
        amount: 100,
        date: date,
        isExpense: true,
        categoryId: 'test_category',
      );

      expect(transaction.title, 'Test Transaction');
      expect(transaction.amount, 100);
      expect(transaction.date, date);
      expect(transaction.isExpense, true);
      expect(transaction.categoryId, 'test_category');
      expect(transaction.isRecurring, false); // Default value
    });

    test('Transaction toMap converts correctly', () {
      final date = DateTime(2023, 1, 1);
      final notificationTime = TimeOfDay(hour: 10, minute: 30);

      final transaction = Transaction(
        id: '123',
        title: 'Test Transaction',
        amount: 100,
        date: date,
        isExpense: true,
        categoryId: 'test_category',
        isRecurring: true,
        recurrencePattern: 'monthly',
        nextDueDate: DateTime(2023, 2, 1),
        enableNotification: true,
        notificationTime: notificationTime,
      );

      final map = transaction.toMap();

      expect(map['id'], '123');
      expect(map['title'], 'Test Transaction');
      expect(map['amount'], 100);
      expect(map['date'], date.millisecondsSinceEpoch);
      expect(map['isExpense'], 1);
      expect(map['categoryId'], 'test_category');
      expect(map['isRecurring'], 1);
      expect(map['recurrencePattern'], 'monthly');
      expect(map['nextDueDate'], DateTime(2023, 2, 1).millisecondsSinceEpoch);
      expect(map['enableNotification'], 1);
      expect(map['notificationHour'], 10);
      expect(map['notificationMinute'], 30);
    });

    test('Transaction fromMap creates object correctly', () {
      final map = {
        'id': '123',
        'title': 'Test Transaction',
        'amount': 100.0,
        'date': DateTime(2023, 1, 1).millisecondsSinceEpoch,
        'isExpense': 1,
        'categoryId': 'test_category',
        'isRecurring': 1,
        'recurrencePattern': 'monthly',
        'nextDueDate': DateTime(2023, 2, 1).millisecondsSinceEpoch,
        'enableNotification': 1,
        'notificationHour': 10,
        'notificationMinute': 30,
      };

      final transaction = Transaction.fromMap(map);

      expect(transaction.id, '123');
      expect(transaction.title, 'Test Transaction');
      expect(transaction.amount, 100.0);
      expect(transaction.date, DateTime(2023, 1, 1));
      expect(transaction.isExpense, true);
      expect(transaction.categoryId, 'test_category');
      expect(transaction.isRecurring, true);
      expect(transaction.recurrencePattern, 'monthly');
      expect(transaction.nextDueDate, DateTime(2023, 2, 1));
      expect(transaction.enableNotification, true);
      expect(transaction.notificationTime?.hour, 10);
      expect(transaction.notificationTime?.minute, 30);
    });

    test('Transaction copyWith works correctly', () {
      final original = Transaction(
        id: '123',
        title: 'Original Title',
        amount: 100,
        date: DateTime(2023, 1, 1),
        isExpense: true,
        categoryId: 'category1',
      );

      final copy = original.copyWith(
        title: 'New Title',
        amount: 200,
      );

      // Changed fields
      expect(copy.title, 'New Title');
      expect(copy.amount, 200);

      // Unchanged fields
      expect(copy.id, '123');
      expect(copy.date, DateTime(2023, 1, 1));
      expect(copy.isExpense, true);
      expect(copy.categoryId, 'category1');
    });
  });
}