import 'package:daily_expense/datetime/datetimehelper.dart';
import 'package:daily_expense/models/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daily_expense/data/hive_database.dart';


class ExpenseData extends ChangeNotifier{
  List<ExpenseItem> overallExpenseList= [];
  // [food,date,amount].....

  final db= HiveDatabase();

  void prepareData(){
    if(db.readData().isNotEmpty){
      overallExpenseList= db.readData();
    }
  }


  List<ExpenseItem> getExpenseList(){
    return overallExpenseList;
  }

  void addNewExpense(ExpenseItem newexpense){
    overallExpenseList.add(newexpense);
    notifyListeners();
    db.savedata(overallExpenseList);
  }

  void deleteExpense(ExpenseItem expense){
    overallExpenseList.remove(expense);
    notifyListeners();
    db.savedata(overallExpenseList);
  }
  
  void updateExpense(ExpenseItem oldExpense, ExpenseItem newExpense){
    int index = overallExpenseList.indexOf(oldExpense);
    if(index != -1){
      overallExpenseList[index] = newExpense;
      notifyListeners();
      db.savedata(overallExpenseList);
    }
  }

  DateTime startOfWeek() {
    final today = DateTime.now();
    return today.subtract(Duration(days: today.weekday % 7));
  }

  Map<String,double> calculateDailyExpenseSummary() {
    Map<String,double> dailyExpenseSummary = {};
    // date (yyyymmdd) : amount

    for(var expense in overallExpenseList) {
     String date= convertDateTimeToString(expense.dateTime);
     double amount= double.parse(expense.amount);

     if(dailyExpenseSummary.containsKey(date)){
       double currentAmount= dailyExpenseSummary[date]!;
       currentAmount+= amount;
       dailyExpenseSummary[date]= currentAmount;
     }
     else{
       dailyExpenseSummary.addAll({date: amount});
     }
    }
    return dailyExpenseSummary;
  }

}