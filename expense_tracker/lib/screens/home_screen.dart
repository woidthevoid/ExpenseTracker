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
    } catch (e) {
      print('Failed to fetch expenses: $e');
      setState(() {
        isLoading = false; // Even if it fails, stop showing loading
      });
    }
  }

  void deleteExpense(String id) {
    setState(() {
      expenses.removeWhere((expense) => expense.id == id);
    });

    APIService().deleteExpense(id).then((_) {
      print('Deleted successfully');
    }).catchError((e) {
      print('Failed to delete: $e');
    });
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
                      onDismissed: (direction) => deleteExpense(expense.id),
                      child: ListTile(
                        title: Text(expense.title),
                        subtitle: Text('${expense.amount.toStringAsFixed(2)} DKK'),
                        trailing: Text(expense.category),
                      ),
                    );
                  },
                ),
    );
  }
}
