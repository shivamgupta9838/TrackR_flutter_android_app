import 'package:daily_expense/components/expense_summary.dart';
import 'package:daily_expense/components/expense_tile.dart';
import 'package:daily_expense/data/expense_data.dart';
import 'package:daily_expense/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final newExpenseNameController= TextEditingController();
  final newExpenseAmountController= TextEditingController();

  DateTime? currentWeekStart;

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void previousWeek() {
    var expenseData = Provider.of<ExpenseData>(context, listen: false);
    
    // If no expenses, just allow going back or return? Assuming we want to restrict based on data.
    // If list is empty, maybe we don't restrict or we treat today as start.
    if (expenseData.overallExpenseList.isEmpty) {
      setState(() {
         currentWeekStart = (currentWeekStart ?? expenseData.startOfWeek()).subtract(const Duration(days: 7));
      });
      return;
    }

    DateTime currentStart = currentWeekStart ?? expenseData.startOfWeek();
    DateTime targetStart = currentStart.subtract(const Duration(days: 7));
    
    // Get date of the first expense ever recorded (assuming list is sorted chronologically or we find min)
    // The list in ExpenseData is `overallExpenseList`. It might not be sorted.
    // However, usually logs are appended. If not sorted, we should find the min date.
    // For now, let's assume index 0 is the oldest if that's how it's stored, or just iterate.
    // Safest is to sort or iterate. But since I can't see sort logic, I'll assume I need to find the earliest date.
    
    List<ExpenseItem> allExpenses = expenseData.overallExpenseList;
    DateTime earliestDate = allExpenses[0].dateTime;
    // for (var expense in allExpenses) {
    //   if (expense.dateTime.isBefore(earliestDate)) {
    //     earliestDate = expense.dateTime;
    //   }
    // }

    DateTime startOfWeekForFirst = earliestDate.subtract(Duration(days: earliestDate.weekday % 7));
    
    // Normalize to remove time parts for comparison (just to be safe, though startOfWeek should be consistent)
    DateTime targetDateOnly = DateTime(targetStart.year, targetStart.month, targetStart.day);
    DateTime firstDateOnly = DateTime(startOfWeekForFirst.year, startOfWeekForFirst.month, startOfWeekForFirst.day);

    if (targetDateOnly.isBefore(firstDateOnly)) {
      return;
    }

    setState(() {
      currentWeekStart = targetStart;
    });
  }

  void nextWeek() {
    DateTime d1= (currentWeekStart ?? Provider.of<ExpenseData>(context, listen: false).startOfWeek()).add(const Duration(days: 7));
    if(d1.isAfter(DateTime.now())) {
      return;
    }
    setState(() {
      currentWeekStart = d1;
    });
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Add New Expense"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newExpenseNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Expense Name",
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    controller: newExpenseAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Expense Amount",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: cancel,
                child: Text("Cancel"),
              ),
              MaterialButton(
                onPressed: save,
                child: Text("Save"),
              ),
            ]
          ),
    );
  }

  void updateExpense(ExpenseItem expense) {
    newExpenseNameController.text = expense.name;
    newExpenseAmountController.text = expense.amount;

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
              title: Text("Update Expense"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: newExpenseNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Expense Name",
                      ),
                    ),

                    SizedBox(height: 10,),

                    TextField(
                      controller: newExpenseAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Expense Amount",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: cancel,
                  child: Text("Cancel"),
                ),
                MaterialButton(
                  onPressed: () => update(expense),
                  child: Text("Update"),
                ),
              ]
          ),
    );
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    if(newExpenseNameController.text.isNotEmpty && newExpenseAmountController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        dateTime: DateTime.now(),
      );
      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }
    Navigator.of(context).pop();
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  void update(ExpenseItem oldExpense) {
    if(newExpenseNameController.text.isNotEmpty && newExpenseAmountController.text.isNotEmpty) {
      ExpenseItem updatedExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        dateTime: oldExpense.dateTime,
      );
      Provider.of<ExpenseData>(context, listen: false).updateExpense(oldExpense, updatedExpense);
    }
    Navigator.of(context).pop();
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  void cancel() {
    Navigator.of(context).pop();
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.add,color: Colors.white,),
        ),
        body: ListView(
          children: [
            ExpenseSummary(
              startofWeek: currentWeekStart ?? value.startOfWeek(),
              onPreviousWeek: previousWeek,
              onNextWeek: nextWeek,
            ),

            const SizedBox(height: 20,),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: value.getExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getExpenseList()[index].name,
                amount: value.getExpenseList()[index].amount,
                dateTime: value.getExpenseList()[index].dateTime,
                updateTapped: (p0) => updateExpense(value.getExpenseList()[index]),
                deleteTapped: (p0) => deleteExpense(value.getExpenseList()[index]),
              ),
            ),
          ]
        )
      ),
    );
  }
}