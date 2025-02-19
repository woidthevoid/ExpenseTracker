import 'package:flutter/material.dart';
import 'package:expense_tracker/components/ExpenseForm.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/services/api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      final fetchedExpenses = await APIService().fetchExpenses();
      setState(() {
        expenses = fetchedExpenses;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Expenses synced successfully'),
        duration: Duration(seconds: 3),
      ));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch data'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> deleteThisExpense(String id) async {
    try {
      await APIService().deleteExpense(id);
      setState(() {
        expenses.removeWhere((expense) => expense.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Expense deleted successfully'),
        duration: Duration(seconds: 3),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete expense'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _openExpenseFormDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Expense'),
        content: ExpenseForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : expenses.isEmpty
              ? Center(child: Text('No expenses found'))
              : RefreshIndicator(
                  onRefresh: fetchExpenses,
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Dismissible(
                        key: Key(expense.id!),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm deletion'),
                                content: Text(
                                    'Are you sure you want to delete this expense?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) async {
                          if (expense.id != null) {
                            await deleteThisExpense(expense.id!);
                          }
                        },
                        child: ListTile(
                          title: Text(expense.title),
                          subtitle: Text('${expense.amount.toStringAsFixed(2)} DKK'),
                          trailing: Text(expense.category),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openExpenseFormDialog,
        child: Icon(Icons.add),
        tooltip: 'New expense',
      ),
    );
  }
}
