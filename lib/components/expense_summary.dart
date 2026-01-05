import 'package:daily_expense/bar_graph/bar_graph.dart';
import 'package:daily_expense/data/expense_data.dart';
import 'package:daily_expense/datetime/datetimehelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget{
  final DateTime startofWeek;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const ExpenseSummary({
    super.key,
    required this.startofWeek,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  String calculateWeekTotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ){
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    double total=0;
    for(var v in values){
      total+=v;
    }
    return total.toStringAsFixed(2);
  }

  double calculateMax(
       ExpenseData value,
       String sunday,
       String monday,
       String tuesday,
       String wednesday,
       String thursday,
       String friday,
       String saturday,
  ){
    double? max;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    values.sort();
    max= values.last*1.1;

    return max <=100 ? 100 : max;
  }

  @override
  Widget build(BuildContext context) {

    String sunday= convertDateTimeToString(startofWeek.add(const Duration(days: 0)));
    String monday= convertDateTimeToString(startofWeek.add(const Duration(days: 1)));
    String tuesday= convertDateTimeToString(startofWeek.add(const Duration(days: 2)));
    String wednesday= convertDateTimeToString(startofWeek.add(const Duration(days: 3)));
    String thursday= convertDateTimeToString(startofWeek.add(const Duration(days: 4)));
    String friday= convertDateTimeToString(startofWeek.add(const Duration(days: 5)));
    String saturday= convertDateTimeToString(startofWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Week Total: ', style: TextStyle(fontWeight: FontWeight.bold),),
                Text('₹ ${calculateWeekTotal(value,sunday,monday,tuesday,wednesday,thursday,friday,saturday)}',),
                Spacer(),
                Text('L'),
                IconButton(onPressed: onPreviousWeek, icon: Icon(Icons.arrow_back),iconSize: 20,),
                IconButton(onPressed: onNextWeek, icon: Icon(Icons.arrow_forward),iconSize: 20,),
                Text('R'),
              ],
            ),
          ),

          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMax(value,sunday,monday,tuesday,wednesday,thursday,friday,saturday),
              sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
              monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
              tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
              wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
              thuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
              friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
              satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,

            )
          ),
        ],
      ),
    );
  }
}
