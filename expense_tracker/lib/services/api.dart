import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/expense.dart';

class APIService {
  static const String _url = 'https://expensetracker-cmdq.onrender.com';

Future<List<Expense>> fetchExpenses() async {
  final response = await http.get(Uri.parse('$_url/expenses'));

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
  
    if (body is List<dynamic>) {
      return body.map((json) => Expense.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Unexpected response format: ${response.body}');
    }
  } else {
    throw Exception('Failed to fetch expenses: ${response.statusCode}');
  }
}

  Future<void> deleteExpense(String id) async {
    final response = await http.delete(Uri.parse('$_url/expenses/$id'));

    if(response.statusCode == 404) {
      throw Exception('Failed to delete expense');
    }
  }

  Future<void> addExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$_url/expenses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(expense.toJson()),
      );

    if(response.statusCode != 201) {
      throw Exception('Failed to add expense');
    }
  }
}
