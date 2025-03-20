import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../services/auth_service.dart';
import '../widgets/category_chart.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final totalIncome = transactionProvider.getTotalIncome(_startDate, _endDate);
    final totalExpense = transactionProvider.getTotalExpense(_startDate, _endDate);
    final netBalance = totalIncome - totalExpense;
    final expensesByCategory = transactionProvider.getExpensesByCategory(_startDate, _endDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard')
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await transactionProvider.loadTransactions();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDateRangePicker(context),
                    icon: const Icon(Icons.date_range),
                    label: const Text('Select Date Range'),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summary',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryItem(
                                context,
                                'Income',
                                totalIncome,
                                Colors.green,
                                Icons.arrow_upward,
                              ),
                            ),
                            Expanded(
                              child: _buildSummaryItem(
                                context,
                                'Expense',
                                totalExpense,
                                Colors.red,
                                Icons.arrow_downward,
                              ),
                            ),
                            Expanded(
                              child: _buildSummaryItem(
                                context,
                                'Balance',
                                netBalance,
                                netBalance >= 0 ? Colors.blue : Colors.orange,
                                Icons.account_balance_wallet,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 24),
                Text(
                  'Spending by Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (expensesByCategory.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('No expenses in this period'),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 320,
                    child: CategoryChart(
                      categoryData: expensesByCategory,
                      categoryProvider: categoryProvider,
                    ),
                  ),
              ],
            ),
          ),
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

  Widget _buildSummaryItem(
      BuildContext context,
      String title,
      double amount,
      Color color,
      IconData icon,
      ) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    try {
      DateTime now = DateTime.now();
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: now,
        initialDateRange: DateTimeRange(
          start: _startDate,
          end: _endDate.isAfter(now) ? now : _endDate,
        ),
      );

      if (picked != null) {
        setState(() {
          _startDate = picked.start;
          _endDate = picked.end;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting date range: $e')),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      await AuthService().signOut();
      Navigator.of(context).pushReplacementNamed('/auth');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
}
