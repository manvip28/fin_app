// lib/screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../services/notification_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isExpense = true;
  String _selectedCategoryId = '';
  bool _isRecurring = false;
  String _recurrencePattern = 'monthly';
  DateTime _nextDueDate = DateTime.now().add(const Duration(days: 30));
  bool _enableNotification = false;
  TimeOfDay _notificationTime = TimeOfDay(hour: 9, minute: 0); // Default to 9:00 AM

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

    // Set default category if not already set and categories are loaded
    if (_selectedCategoryId.isEmpty && categories.isNotEmpty) {
      _selectedCategoryId = categories.first.id!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
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
                        // Update selected category based on transaction type
                        if (categories.isNotEmpty) {
                          if (_isExpense) {
                            // Find first expense category
                            final expenseCategory = categories.firstWhere(
                                  (c) => c.name != 'Salary',
                              orElse: () => categories.first,
                            );
                            _selectedCategoryId = expenseCategory.id!;
                          } else {
                            // Find income category
                            final incomeCategory = categories.firstWhere(
                                  (c) => c.name == 'Salary',
                              orElse: () => categories.first,
                            );
                            _selectedCategoryId = incomeCategory.id!;
                          }
                        }
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
                value: categories.isNotEmpty ? _selectedCategoryId : null,
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
                          _nextDueDate = _selectedDate.add(const Duration(days: 1));
                          break;
                        case 'weekly':
                          _nextDueDate = _selectedDate.add(const Duration(days: 7));
                          break;
                        case 'monthly':
                          _nextDueDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month + 1,
                            _selectedDate.day,
                          );
                          break;
                        case 'yearly':
                          _nextDueDate = DateTime(
                            _selectedDate.year + 1,
                            _selectedDate.month,
                            _selectedDate.day,
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
                const SizedBox(height: 16),
                // Notification toggle
                SwitchListTile(
                  title: const Text('Enable Notification'),
                  subtitle: const Text('Get reminded before the due date'),
                  value: _enableNotification,
                  onChanged: (value) {
                    setState(() {
                      _enableNotification = value;
                    });
                  },
                ),
                if (_enableNotification) ...[
                  const SizedBox(height: 8),
                  // Notification time picker
                  ListTile(
                    title: const Text('Notification Time'),
                    subtitle: Text(_notificationTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _notificationTime,
                      );
                      if (picked != null) {
                        setState(() {
                          _notificationTime = picked;
                        });
                      }
                    },
                  ),
                ],
              ],
              const SizedBox(height: 24),
              // Save button
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);

      final transaction = Transaction(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        isExpense: _isExpense,
        categoryId: _selectedCategoryId,
        isRecurring: _isRecurring,
        recurrencePattern: _isRecurring ? _recurrencePattern : null,
        nextDueDate: _isRecurring ? _nextDueDate : null,
        enableNotification: _isRecurring && _enableNotification,
        notificationTime: _isRecurring && _enableNotification
            ? _notificationTime
            : null,
      );

      await transactionProvider.addTransaction(transaction);

      // Schedule notification if needed
      if (_isRecurring && _enableNotification) {
        final notificationService = NotificationService();
        await notificationService.scheduleTransactionReminder(transaction);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction added successfully'),
        ),
      );

      Navigator.pop(context);
    }
  }
}