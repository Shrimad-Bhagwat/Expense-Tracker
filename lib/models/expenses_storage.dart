import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpensesStorage {
  Future<void> saveExpenses(List<Expense> expenses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String expenseString = expenses.map((expense) {
      return "${expense.title}|${expense.amount}|${expense.date.toIso8601String()}|${expense.category}";
    }).join(";");
    await prefs.setString('expenses', expenseString);
  }

  Future<List<Expense>> loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? expenseString = prefs.getString('expenses');
    List<Expense> expenses = [];
    if (expenseString != null && expenseString.isNotEmpty) {
      List<String> expenseList = expenseString.split(";");
      expenses = expenseList.map((expenseString) {
        List<String> values = expenseString.split("|");
        return Expense(
          title: values[0],
          amount: double.parse(values[1]),
          date: DateTime.parse(values[2]),
          category: Category.values.firstWhere((e) => e.toString() == values[3]),
        );
      }).toList();
    }
    return expenses;
  }
}
