
import 'package:daily_expense/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDatabase{
  final _mybox= Hive.box("expense_database");

  void savedata(List<ExpenseItem> allExpenses){
    List<List<dynamic>> allExpenseFormatted=[];

    for(var expense in allExpenses){
      List<dynamic> expenseFormatted= [
        expense.name,
        expense.amount,
        expense.dateTime
      ];
      allExpenseFormatted.add(expenseFormatted);
    }
    _mybox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  List<ExpenseItem> readData(){
    List savedExpenses= _mybox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses= [];

    for(int i=0; i< savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItem newExpense= ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );
      allExpenses.add(newExpense);
    }
    return allExpenses;
  }

}