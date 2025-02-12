import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/expense.dart';

class APIService {
  static const String _url = 'http://localhost:5001';

  Future<List<Expense>> fetchExpenses() async {
    final response = await http.get(Uri.parse('$_url/expenses'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;
      return jsonResponse.map((json) => Expense.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to fetch expenses');
    }
  }

  Future<void> deleteExpense(String id) async {
    final response = await http.delete(Uri.parse('$_url/expenses/$id'));

    if(response.statusCode != 200) {
      throw Exception('Failed to delete expense');
    }
  }
}
