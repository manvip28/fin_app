// lib/screens/edit_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late bool _isExpense;
  late String _selectedCategoryId;
  late bool _isRecurring;
  late String _recurrencePattern;
  late DateTime _nextDueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _selectedDate = widget.transaction.date;
    _isExpense = widget.transaction.isExpense;
    _selectedCategoryId = widget.transaction.categoryId;
    _isRecurring = widget.transaction.isRecurring;
    _recurrencePattern = widget.transaction.recurrencePattern ?? 'monthly';
    _nextDueDate = widget.transaction.nextDueDate ?? DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transaction type switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Income'),
                  Switch(
                    value: _isExpense,
                    onChanged: (value) {
                      setState(() {
                        _isExpense = value;
                      });
                    },
                  ),
                  const Text('Expense'),
                ],
              ),
              const SizedBox(height: 16),
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Amount field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Date picker
              ListTile(
                title: const Text('Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              // Category dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategoryId,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Recurring transaction toggle
              SwitchListTile(
                title: const Text('Recurring Transaction'),
                value: _isRecurring,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
              ),
              if (_isRecurring) ...[
                const SizedBox(height: 8),
                // Recurrence pattern dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Recurrence Pattern',
                    border: OutlineInputBorder(),
                  ),
                  value: _recurrencePattern,
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                    DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _recurrencePattern = value!;
                      // Update next due date based on pattern
                      switch (_recurrencePattern) {
                        case 'daily':
                          _nextDueDate = DateTime.now().add(const Duration(days: 1));
                          break;
                        case 'weekly':
                          _nextDueDate = DateTime.now().add(const Duration(days: 7));
                          break;
                        case 'monthly':
                          _nextDueDate = DateTime(
                            DateTime.now().year,
                            DateTime.now().month + 1,
                            DateTime.now().day,
                          );
                          break;
                        case 'yearly':
                          _nextDueDate = DateTime(
                            DateTime.now().year + 1,
                            DateTime.now().month,
                            DateTime.now().day,
                          );
                          break;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Next due date picker
                ListTile(
                  title: const Text('Next Due Date'),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(_nextDueDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _nextDueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (picked != null) {
                      setState(() {
                        _nextDueDate = picked;
                      });
                    }
                  },
                ),
              ],
              const SizedBox(height: 24),
              // Update button
              ElevatedButton(
                onPressed: _updateTransaction,
                child: const Text('Update Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTransaction() async {
    if (_formKey.currentState!.validate()) {
      final transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);

      final updatedTransaction = Transaction(
        id: widget.transaction.id,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        isExpense: _isExpense,
        categoryId: _selectedCategoryId,
        isRecurring: _isRecurring,
        recurrencePattern: _isRecurring ? _recurrencePattern : null,
        nextDueDate: _isRecurring ? _nextDueDate : null,
      );

      await transactionProvider.updateTransaction(updatedTransaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction updated successfully'),
        ),
      );

      Navigator.pop(context);
    }
  }
}
// TODO Implement this library.