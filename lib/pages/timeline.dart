// /// Example of a stacked area chart.
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter/material.dart';

// class CountryTimeline extends StatelessWidget {
//   late List<CountryData> data = [];

//   CountryTimeline({required this.data});
  
//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<CountryData, String>> series =[
//       chart.Series(
//         id: "Subscribers"
//       )
//     ]
//     return charts.BarChart();
//   }
// }

// class CountryData {
//   final String date;
//   final int count;
//   final charts.Color barColor;

//   CountryData(this.date, this.count, this.barColor);
// }
