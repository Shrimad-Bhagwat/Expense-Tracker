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
class _ExpensesState extends State<Expenses> {
  final ExpensesStorage _expensesStorage = ExpensesStorage();
  @override
  void initState() {
    super.initState();

    _loadExpenses();
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
        content: const Text('Expense Deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: (){
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
          _expensesStorage.saveExpenses(_registeredExpenses);
        }),
      ),
    );
  }

  // void _addExpense(Expense expense) {
  //   setState(() {
  //     _registeredExpenses.add(expense);
  //   });
  // }
  //
  // void _removeExpense(Expense expense) {
  //   final expenseIndex = _registeredExpenses.indexOf(expense);
  //   setState(() {
  //     _registeredExpenses.remove(expense);
  //   });
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       duration: const Duration(seconds: 3),
  //       content: const Text('Expense Deleted'),
  //       action: SnackBarAction(label: 'Undo', onPressed: (){
  //         setState(() {
  //           _registeredExpenses.insert(expenseIndex, expense);
  //         });
  //       }),
  //     ),
  //   );
  // }

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
    // print(width);

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
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
        ],
      ),
      body: width <600 ? Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent),
        ],
      ) : Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
