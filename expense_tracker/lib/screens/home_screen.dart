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

  @override
  void initState() {
    super.initState();

    Future<void> fetchExpenses() async {
      try {
        final fetchedExpenses = await APIService().fetchExpenses();
        setState(() {
          expenses = fetchedExpenses;
        });
      } catch (e) {
        print('Failed to fetch expenses: $e');
      }
    }
  
    @override
    void initState() {
      super.initState();
      fetchExpenses();
    }
  }

  void deleteExpense(String id) {
    setState(() {
      expenses.removeWhere((expense) => expense.id == id);
      APIService().deleteExpense(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Expenses')),
      body: expenses.isEmpty 
      ? Center(child: CircularProgressIndicator())
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
              child: Icon(Icons.delete, color: Colors.white,),
            ),
            onDismissed: (direction) => deleteExpense(expense.id),
            child: ListTile(
              title: Text(expense.title),
              subtitle: Text('${expense.amount} DKK'),
              trailing: Text(expense.category),
            )
            );
        }
      )
    );
  }
}
