import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:covid_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

import 'dart:convert';

class Country extends StatefulWidget {
  final String code;

  const Country({Key? key, this.code: ""}) : super(key: key);
  @override
  _CountryState createState() => _CountryState();
}

class _CountryState extends State<Country> {
  Map data = {};

  List timeline = [];
  List<double> deaths = [];
  List<String> stringDeaths = [];

  Future getCountries() async {
    http.Response response = await http
        .get(Uri.parse("https://corona-api.com/countries/" + widget.code));

    data = jsonDecode(response.body);
    print(data['data']);

    setState(() {
      data = data['data'];
      timeline = data['timeline'];
      if (timeline.length > 1) {
        timeline = timeline.sublist(0, 6);

        timeline.forEach((element) {
          deaths.add(element['deaths'].toDouble());
        });
        List<double> temp = [];
        List<double> temp2 = [];
        temp2 = deaths;
        temp2.sort();
        var largeDeath = temp2[temp2.length - 1];

        deaths.forEach((element) {
          temp.add(element / largeDeath);
        });

        print("TEMPPPP");
        print(temp);

        deaths.sort();

        deaths.forEach((element) {
          stringDeaths.add(element.toString());
        });

        deaths = temp;
        print("timeline ");
        print(timeline);
        print("deaths ");
        print(deaths);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 14),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: textColor,
                        )),
                  ),
                  Flexible(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          data['name'] == null
                              ? "Loading ..."
                              : data['name'] + ' ' + '- ' + data['code'],
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 28,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(30),
                  margin: EdgeInsets.all(10),
                  color: secondaryBg,
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Recent Data",
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 22,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Deaths :",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data['latest_data'] != null &&
                                              data['latest_data']['deaths']
                                                      .toString()
                                                      .length >
                                                  0
                                          ? " " +
                                              data['latest_data']['deaths']
                                                  .toString()
                                          : "N/A",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 14,
                                        color: textColor,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Confirmed :",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data['latest_data'] != null &&
                                              data['latest_data']['confirmed']
                                                      .toString()
                                                      .length >
                                                  0
                                          ? " " +
                                              data['latest_data']['confirmed']
                                                  .toString()
                                          : "N/A",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 14,
                                        color: textColor,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Recovered :",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data['latest_data'] != null &&
                                              data['latest_data']['recovered']
                                                      .toString()
                                                      .length >
                                                  0
                                          ? " " +
                                              data['latest_data']['recovered']
                                                  .toString()
                                          : "N/A",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 14,
                                        color: textColor,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Critical :",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data['latest_data'] != null &&
                                              data['latest_data']['critical']
                                                      .toString()
                                                      .length >
                                                  0
                                          ? " " +
                                              data['latest_data']['critical']
                                                  .toString()
                                          : "N/A",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 14,
                                        color: textColor,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Cases per million population :",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data['latest_data'] != null &&
                                              data['latest_data']["calculated"][
                                                          'cases_per_million_population']
                                                      .toString()
                                                      .length >
                                                  0
                                          ? " " +
                                              data['latest_data']["calculated"][
                                                      'cases_per_million_population']
                                                  .toString()
                                          : "N/A",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 14,
                                        color: textColor,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(20)),
                                _percentageGraph(
                                    data["latest_data"] != null &&
                                            data["latest_data"]["calculated"]
                                                    ["death_rate"] !=
                                                null
                                        ? data["latest_data"]["calculated"]
                                            ["death_rate"]
                                        : 0,
                                    "Death Rate"),
                                _percentageGraph(
                                    data["latest_data"] != null &&
                                            data["latest_data"]["calculated"]
                                                    ["recovery_rate"] !=
                                                null
                                        ? data["latest_data"]["calculated"]
                                            ["recovery_rate"]
                                        : 0,
                                    "Recovery Rate"),
                                _percentageGraph(
                                    data["latest_data"] != null &&
                                            data["latest_data"]["calculated"][
                                                    "recovered_vs_death_ratio"] !=
                                                null
                                        ? data["latest_data"]["calculated"]
                                            ["recovered_vs_death_ratio"]
                                        : 0.0,
                                    "Recovered Vs Death Percentage"),
                                // _percentageGraph(
                                //     data["latest_data"] != null &&
                                //             data["latest_data"]["calculated"][
                                //                     "cases_per_million_population"] !=
                                //                 null
                                //         ? data["latest_data"]["calculated"]
                                //                 ["cases_per_million_population"]
                                //             .toDouble()
                                //         : 0,
                                //     "Cases per million population"),

                                Container(
                                  child: MyScreen(
                                      numdeaths: deaths,
                                      timeline: timeline,
                                      deaths: stringDeaths),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _percentageGraph(double ratio, String placeholderText) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 8.0,
            animation: true,
            percent: ratio > 0 ? ratio / 100 : 0,
            center: Text(
              ratio > 0 ? ratio.floor().toString() + "%" : "N/A",
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: textColor),
            ),
            backgroundColor: primaryBg,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: purpleColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              placeholderText,
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: textColor),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MyScreen extends StatelessWidget {
  final List timeline;
  final List<double> numdeaths;
  final List<String> deaths;

  MyScreen({
    Key? key,
    required this.numdeaths,
    required this.timeline,
    required this.deaths,
  }) : super(key: key);

  late List<Feature> deathFeatures = [
    Feature(
      title: "Recovered",
      color: Colors.blue,
      data: [0.2, 0.8, 0.4, 0.7, 0.6],
    ),
    Feature(
      title: "Deaths",
      color: Colors.pink,
      // data: numdeaths,
      data: numdeaths,
    ),
    Feature(
      title: "Confirmed",
      color: Colors.cyan,
      data: [0.5, 0.4, 0.85, 0.4, 0.7],
    ),
    Feature(
      title: "Active",
      color: Colors.yellow,
      data: [0.6, 0.4, 0.6, 0.5, 1],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12),
          child: Text(
            "Recent Data",
            style: GoogleFonts.sourceSansPro(
              fontSize: 20,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: timeline.length > 1
              ? LineGraph(
                  features: deathFeatures,
                  size: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.45),
                  labelX: [
                    timeline[0]['date'].toString(),
                    timeline[1]['date'].toString(),
                    timeline[2]['date'].toString(),
                    timeline[3]['date'].toString(),
                    timeline[4]['date'].toString(),
                  ],
                  labelY: deaths,
                  showDescription: true,
                  graphColor: textColor,
                  graphOpacity: 0.2,
                  verticalFeatureDirection: true,
                  descriptionHeight: 130,
                )
              : Text(
                  "N/A",
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
