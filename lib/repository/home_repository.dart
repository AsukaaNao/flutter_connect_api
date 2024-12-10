// import 'package:depd_2024_mvvm/data/network/network_api_services.dart';
// import 'package:depd_2024_mvvm/model/model.dart';

import 'package:flutterapp_depd/data/app_exception.dart';
import 'package:flutterapp_depd/data/network/network_api_services.dart';
import 'package:flutterapp_depd/model/city.dart';
import 'package:flutterapp_depd/model/costs/costresponse.dart';
import 'package:flutterapp_depd/model/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/province');
      List<Province> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      }
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<List<City>> fetchCityList(var provinceId) async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/city');
      List<City> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      }

      List<City> selectedCities = [];
      for (var c in result) {
        if (c.provinceId == provinceId) {
          selectedCities.add(c);
        }
      }

      return selectedCities;
    } catch (e) {
      throw e;
    }
  }

  Future<CostResponse> calculateCost({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    try {
      // final body = {
      //   'origin': origin,
      //   'destination': destination,
      //   'weight': weight,
      //   'courier': courier,
      // };

      final body = {
        'origin': origin,
        'destination': destination,
        'weight': weight.toString(),
        'courier': courier,
      };

      // Debug: Log the request body
      print("DEBUG: Request Body -> $body");

      dynamic response =
          await _apiServices.postApiResponse('/starter/cost', body);

      // Debug: Log the raw response
      print("DEBUG: Raw Response -> $response");

      if (response['rajaongkir']['status']['code'] == 200) {
        // Debug: Log the status code
        print(
            "DEBUG: Status Code -> ${response['rajaongkir']['status']['code']}");
        return CostResponse.fromJson(response['rajaongkir']['results'][0]);
      }

      throw FetchDataException('Something went wrong');
    } catch (e) {
      // Debug: Log the error
      print("DEBUG: Error calculating cost -> $e");
      throw e;
    }
  }
}
