// lib/screens/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/transaction_card.dart';
import 'add_transaction_screen.dart';
import 'edit_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final transactions = transactionProvider.transactions;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
        ),
        body: RefreshIndicator(
        onRefresh: () async {
      await transactionProvider.loadTransactions();
    },
    child: transactions.isEmpty
    ? const Center(
    child: Text('No transactions yet. Add one!'),
    )
        : ListView.builder(
    itemCount: transactions.length,
    itemBuilder: (context, index) {
    final transaction = transactions[index];
    return TransactionCard(
    transaction: transaction,
    categoryName: categoryProvider.getCategoryNameById(
    transaction.categoryId),
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => EditTransactionScreen(
    transaction: transaction,
    ),
    ),
    );
    },
    onDelete: () async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
    title: const Text('Delete Transaction'),
    content: const Text(
    'Are you sure you want to delete this transaction?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Delete'), // Only one 'child' specified here
        ),
      ],

    ),
    );

    if (confirmed == true) {
      await transactionProvider.deleteTransaction(transaction.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction deleted'),
        ),
      );
    }
    },
    );
    },
    ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

