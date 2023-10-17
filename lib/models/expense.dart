import 'package:uuid/uuid.dart';

// To generate unique id's
const uuid = Uuid();

enum Category {
  food,
  travel,
  leisure,
  work
}

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4(); // Generates unique string id

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
}