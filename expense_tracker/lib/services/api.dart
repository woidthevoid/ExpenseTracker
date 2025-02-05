import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/expense.dart';

class APIService {
  static const String _url = 'http://localhost:5001';

  Future<Expense> fetchExpenses() async {
    final response = await http.get(Uri.parse('$_url/expenses'));

    if (response.statusCode == 200) {
      return Expense.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch expenses');
    }
  }
}
