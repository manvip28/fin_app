// lib/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final String categoryName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.categoryName,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: transaction.isExpense ? Colors.red : Colors.green,
          child: Icon(
            transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white,
          ),
        ),
        title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$categoryName • ${_formatDate(transaction.date)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: transaction.isExpense ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}