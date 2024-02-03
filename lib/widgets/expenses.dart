import 'dart:io';
import 'dart:math';

import 'package:excel/excel.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/expenses_storage.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

List<Expense> _registeredExpenses = [];
List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class _ExpensesState extends State<Expenses> {
  final ExpensesStorage _expensesStorage = ExpensesStorage();

  @override
  void initState() {
    super.initState();

    _loadExpenses();
  }

  double calculateTotalExpense() {
    double total = 0;
    for (Expense expense in _registeredExpenses) {
      total += expense.amount;
    }
    return total;
  }

  Future<void> _loadExpenses() async {
    List<Expense> loadedExpenses = await _expensesStorage.loadExpenses();
    setState(() {
      _registeredExpenses = loadedExpenses;
    });
  }

  Future<void> _addExpense(Expense expense) async {
    setState(() {
      _registeredExpenses.add(expense);
    });
    await _expensesStorage.saveExpenses(_registeredExpenses);
  }

  Future<void> _removeExpense(Expense expense) async {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    await _expensesStorage.saveExpenses(_registeredExpenses);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: kColorScheme.primaryContainer,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        content: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Expense Deleted', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),),
        ),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
              _expensesStorage.saveExpenses(_registeredExpenses);
            }),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found!'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
              onPressed: () {
                showDownloadAlert();
                // exportToExcel(_registeredExpenses, context);
              },
              icon: const Icon(Icons.download_rounded)),
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
                // Bottom bar with total expense
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Total Expense : ₹ ${calculateTotalExpense()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
      // floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.add),),
    );
  }

  void showDownloadAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export to Excel'),
          content: const Text('Are you sure you want to export expenses to Excel?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await exportToExcel(_registeredExpenses, context);
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> exportToExcel(List<Expense> expenses, BuildContext context) async {
  // Create an Excel workbook and add a worksheet
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['Expense Details'];

  // Add headers to the worksheet
  sheet.appendRow([
    const TextCellValue('Date'),
    const TextCellValue('Description'),
    const TextCellValue('Category'),
    const TextCellValue('Amount'),
  ]);

  // Add expense data to the worksheet
  for (Expense expense in expenses) {
    var formattedDate =
        "${expense.date.day}-${expense.date.month}-${expense.date.year}";
    var category = expense.category.toString().split('.')[1].toUpperCase();
    // print("$formattedDate $category");
    sheet.appendRow([
      TextCellValue(formattedDate),
      TextCellValue(expense.title.toString()),
      TextCellValue(category),
      TextCellValue(expense.amount.toString()),
    ]);
  }

  // Save the Excel file

  try {
    var month = DateTime.now().month;
    final file =
        File('/storage/emulated/0/Download/${months[month - 1]}_expenses.xlsx');
    file.writeAsBytes(excel.encode()!);
    ScaffoldMessenger.of(context).showSnackBar(
        showMessage("Excel exported to Downloads!", Colors.green));

  } on Exception catch (_) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
        showMessage("Error!", Colors.red[200]!)
    );
  }
}

SnackBar showMessage(String title, Color color) {
  return SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: color,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
}
