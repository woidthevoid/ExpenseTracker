import 'package:expense_tracker/model/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ChartType {line, bar, pie}

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;
  final ChartType type;

  const ExpenseChart({
    super.key,
    required this.expenses,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch(type) {
      case ChartType.line:
      return buildLineChart();
      case ChartType.pie:
      return buildPieChart();
      case ChartType.bar:
      return buildBarChart();
    }
  }

  Widget buildLineChart() {
    final expenseByDate = <DateTime, double>{};
    for (var expense in expenses) {
      final dateKey = DateTime(expense.date.year, expense.date.month, expense.date.day);
      expenseByDate.update(dateKey, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }
    final sortedDates = expenseByDate.keys.toList()..sort();
    final spots = sortedDates.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final date = entry.value;
      return FlSpot(index, expenseByDate[date]!);
    }).toList();
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              spots: spots
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPieChart() {
    final expenseByCategory = <String, double>{};
    for (var expense in expenses) {
      expenseByCategory.update(expense.category, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }
    final sections = expenseByCategory.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
      );
    }).toList();
    
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
        )
      ),
    );
  }

   Widget buildBarChart() {
    final expenseByDate = <String, double>{};
    for (var expense in expenses) {
      final dateKey = "${expense.date.year}-${expense.date.month}-${expense.date.day}";
      expenseByDate.update(dateKey, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }

    final sortedDates = expenseByDate.keys.toList()..sort();
    final barGroups = sortedDates.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: expenseByDate[date]!,
            color: Colors.blue,
            width: 15,
          ),
        ],
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          barGroups: barGroups,
        ),
      ),
    );
  }
}