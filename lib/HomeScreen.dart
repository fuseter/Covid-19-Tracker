import 'dart:convert';
import 'package:covid19/theme.dart';
import 'package:covid19/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _covidData;

  int confirmed;
  int recovered;
  int hospitalized;
  int deaths;
  var updateDate;
  int province;
  var allProvinceName = ["ทั้งหมด"];
  String _location = "ทั้งหมด";

  void initState() {
    super.initState();
    fetchCovidData();
    fetchProvinceName();
  }

// ทั้งประเทศ
  void fetchCovidData() async {
    var api = "https://covid19.th-stat.com/api/open/today";
    var response = await http.get(api);
    if (response.statusCode == 200) {
      var covid = json.decode(response.body);
      setState(() {
        confirmed = covid["Confirmed"];
        recovered = covid["Recovered"];
        hospitalized = covid["Hospitalized"];
        deaths = covid["Deaths"];
        updateDate = covid["UpdateDate"];
      });
    }
  }

// ชื่อจังหวัดทั้งหมด
  void fetchProvinceName() async {
    var api = "https://covid19.th-stat.com/api/open/cases/sum";
    var response = await http.get(api);
    if (response.statusCode == 200) {
      var location = json.decode(response.body);
      var resprovinceName = location["Province"];
      var newprovince = ["ทั้งหมด"];
      resprovinceName.forEach((key, value) {
        newprovince.add(key);
        setState(() {
          setState(() {
            allProvinceName = newprovince;
          });
        });
      });
    }
  }

// ผู้จิดเชื้อตาม Dropdown จังหวัด
  void fetchLocationData(String value) async {
    var api = "https://covid19.th-stat.com/api/open/cases/sum";
    var response = await http.get(api);
    if (response.statusCode == 200) {
      var location = json.decode(response.body);
      setState(() {
        province = location["Province"][value];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          ClipPath(
            clipper: Clipper(),
            child: Container(
              padding: EdgeInsets.only(left: 10, top: 20, right: 20),
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFFF0932B), Color(0xFFF0932B)]),
                  image: DecorationImage(
                    image: AssetImage("assets/images/virus.png"),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: 10),
                  Expanded(
                      child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(1, 0, 0, 0),
                        child: SvgPicture.asset(
                          "assets/icons/Drcorona.svg",
                          width: 230,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      Positioned(
                        top: 45,
                        left: 140,
                        child: Column(
                          children: <Widget>[
                            Text("รายงานสถานการณ์",
                                style: kHeadingTextStyle.copyWith(
                                    color: Colors.white, fontFamily: 'Prompt')),
                            Text(
                              "Covid-19",
                              style: kHeadingTextStyle.copyWith(
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(),
                    ],
                  ))
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "เลือกตามจังหวัด\n",
                            style: kTitleTextstyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                )),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 20, 0),
                    child: SvgPicture.asset("assets/icons/maps-and-flags.svg")),
                SizedBox(width: 15),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    underline: SizedBox(),
                    icon: Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: SvgPicture.asset("assets/icons/dropdown.svg")),
                    value: _location,
                    items: allProvinceName
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      fetchLocationData(value);
                      setState(() {
                        _location = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "อัพเดทล่าสุด \n",
                            style: kTitleTextstyle,
                          ),
                          TextSpan(
                            text: updateDate == null ? "" : updateDate,
                            style: TextStyle(
                              color: kTextLightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _location != "ทั้งหมด"
                    ? Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Counter(
                              color: kInfectedColor,
                              number: province == null ? 0 : province,
                              title: "$_location ติดเชื้อสะสม",
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Counter(
                              color: kInfectedColor,
                              number: confirmed == null ? 0 : confirmed,
                              title: "ติดเชื้อสะสม",
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 15),
                _location != "ทั้งหมด"
                    ? Text("")
                    : Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Counter(
                              color: khospitalized,
                              number: hospitalized == null ? 0 : hospitalized,
                              title: "รักษาอยู่ใน รพ.",
                            ),
                            Counter(
                              color: kDeathColor,
                              number: deaths == null ? 0 : deaths,
                              title: "เสียชีวิต",
                            ),
                            Counter(
                              color: kRecovercolor,
                              number: recovered == null ? 0 : recovered,
                              title: "หายแล้ว",
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
