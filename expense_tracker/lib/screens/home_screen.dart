import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/services/api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    fetchExpenses(); // Call fetchExpenses directly
  }

  Future<void> fetchExpenses() async {
    try {
      final fetchedExpenses = await APIService().fetchExpenses();
      setState(() {
        expenses = fetchedExpenses;
        isLoading = false; // Update loading state
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Expenses synced successfully'),
        duration: Duration(seconds: 3),
      ));
    } catch (e) {
      setState(() {
        isLoading = false; // Even if it fails, stop showing loading
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch data'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red));
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
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : expenses.isEmpty
              ? Center(child: Text('No expenses found'))
              : ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return Dismissible(
                      key: Key(expense.id),
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
                                    Navigator.of(context).pop(
                                        false); // Return false to cancel the dismissal
                                  },
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () async {
                                    Navigator.of(context).pop(
                                        true); // Return true to confirm the dismissal
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async {
                        await deleteThisExpense(expense.id);
                      },
                      child: ListTile(
                        title: Text(expense.title),
                        subtitle:
                            Text('${expense.amount.toStringAsFixed(2)} DKK'),
                        trailing: Text(expense.category),
                      ),
                    );
                  },
                ),
    );
  }
}
