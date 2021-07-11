import 'dart:convert';

import 'package:covid_app/pages/country.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:covid_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map data = {};
  List userData = [];
  List filteredSearch = [];

  Future getCountries() async {
    http.Response response =
        await http.get(Uri.parse("https://corona-api.com/countries"));

    data = jsonDecode(response.body);
    print(data['data']);
    setState(() {
      userData = data["data"];
      filteredSearch = data["data"];
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
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Covid Tracker",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 28,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                alignment: Alignment.topLeft,
              ),
              Expanded(
                child: SizedBox(
                  child: new ListView.builder(
                    itemCount: filteredSearch.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index == 0 ? _searchBar() : _listItem(index - 1);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _listItem(int index) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Card(
        color: secondaryBg,
        child: InkWell(
          splashColor: purpleColor,
          onTap: () => {
            // print(filteredSearch[index]["name"]),

            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  Country(code: filteredSearch[index]["code"]),
            )),
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(14, 10, 14, 5),
                        child: Text(
                          filteredSearch[index]["name"],
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 20,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(14, 5, 14, 14),
                        child: Text(
                          "Population : " +
                              filteredSearch[index]["population"].toString(),
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 80.0,
                        lineWidth: 8.0,
                        animation: true,
                        percent: filteredSearch[index]["latest_data"]
                                    ["calculated"]["recovery_rate"] !=
                                null
                            ? filteredSearch[index]["latest_data"]["calculated"]
                                    ["recovery_rate"] /
                                100
                            : 0,
                        center: Text(
                          filteredSearch[index]["latest_data"]["calculated"]
                                      ["recovery_rate"] !=
                                  null
                              ? filteredSearch[index]["latest_data"]
                                          ["calculated"]["recovery_rate"]
                                      .floor()
                                      .toString() +
                                  "%"
                              : "N/A",
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
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Recovery Rate",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: textColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }

  _searchBar() {
    return Container(
      padding: EdgeInsets.all(14),
      child: TextField(
        decoration: InputDecoration(
            focusColor: textColor,
            hintText: "Search for a country",
            hintStyle: TextStyle(color: textColor),
            hoverColor: textColor),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            filteredSearch = userData.where(
              (element) {
                var countryName = element['name'].toLowerCase();
                return countryName.contains(text);
              },
            ).toList();
          });
        },
      ),
    );
  }
}
