import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:smart_village/models/health/vaccine_data.dart';

class HealthCareProvider with ChangeNotifier {
  Dio dio = new Dio();
  String baseUrl = "https://cdn-api.co-vin.in/api";

  Future<VaccineData> getVaccinationSessions(String pincode) async {
    Response x = await dio.get(
      baseUrl + "/v2/appointment/sessions/public/calendarByPin",
      queryParameters: {
        "pincode": pincode == "" ? "125001" : pincode,
        "date": DateFormat('dd-MM-yyyy').format(DateTime.now())
      },
      options: Options(
        headers: {"accept": "application/json", "Accept-Language": "hi_IN"},
      ),
    );
    print(x.data);
    return VaccineData.fromJson(x.data);
  }
}
