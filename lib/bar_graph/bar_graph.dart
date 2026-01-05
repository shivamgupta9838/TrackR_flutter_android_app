import 'package:daily_expense/bar_graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;

  const MyBarGraph({
    super.key,
    this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount
  });

  @override
  Widget build(BuildContext context) {

    BarData myBarData= BarData(
      sunAmount: sunAmount,
      monAmount: monAmount,
      tueAmount: tueAmount,
      wedAmount: wedAmount,
      thuAmount: thuAmount,
      friAmount: friAmount,
      satAmount: satAmount,
    );
    myBarData.initializerBarData();


    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show:false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              const style= TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return Text(
                value.toInt().toString(),
                style: style,
              );
            },
          )),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
              reservedSize: 25
            )
          )
        ),
        barGroups: myBarData.barData.map((data) =>
          BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y,
                color: Colors.grey[800],
                width: 25,
                borderRadius: BorderRadius.circular(2),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: Colors.grey[200],
                ),
              ),
            ]
          ),).toList(),

      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta){
  const style= TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  switch(value.toInt()){
    case 0:
      text= const Text("S",style: style);
    case 1:
      text= const Text("M",style: style);
    case 2:
      text= const Text("T",style: style);
    case 3:
      text= const Text("W",style: style);
    case 4:
      text= const Text("T",style: style);
    case 5:
      text= const Text("F",style: style);
    case 6:
      text= const Text("S",style: style);
    default:
      text= const Text("",style: style);
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
