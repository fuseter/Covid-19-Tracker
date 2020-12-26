import 'package:covid19/models/covid.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HttpService {
  final String api = "https://covid19.th-stat.com/api/open/today";
  Future<List<Covid>> getData() async {
    Response res = await get(api);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Covid> covid =
          body.map((dynamic item) => Covid.fromJson(item)).toList();
      print("res $covid");
      return covid;
    } else {
      throw "ไม่สามารถ get ข้อมูลได้";
    }
  }
}
