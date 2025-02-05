class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'title': String title,
        'amount': double amount,
        'category': String category,
        'date': DateTime date,
      } => 
      Expense(
        title: title,
        id: id,
        amount: amount,
        category: category,
        date: date,
      ),
      _ => throw const FormatException('Expense.fromJson: Unexpected JSON structure'),
    };
  }
}