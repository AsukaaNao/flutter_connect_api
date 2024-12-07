// import 'package:depd_2024_mvvm/data/network/network_api_services.dart';
// import 'package:depd_2024_mvvm/model/model.dart';

import 'package:flutterapp_depd/data/network/network_api_services.dart';
import 'package:flutterapp_depd/model/city.dart';
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

  // Future<List<City>> fetchCityList(var provinceId) async {
  //   try {
  //     dynamic response =
  //         await _apiServices.getApiResponse('/starter/city/$provinceId');
  //     List<City> result = [];

  //     if (response['rajaongkir']['status']['code'] == 200) {
  //       result = (response['rajaongkir']['results'] as List)
  //           .map((e) => City.fromJson(e))
  //           .toList();
  //     }

  //     List<City> selectedCities = [];
  //     for (var c in result) {
  //       if (c.provinceId == provinceId) {
  //         selectedCities.add(c);
  //       }
  //     }

  //     return selectedCities;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<List<City>> fetchCityList(var provinceId) async {
    try {
      dynamic response =
          await _apiServices.getApiResponse('/starter/city/$provinceId');
      if (response['rajaongkir']['status']['code'] == 200) {
        return (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw e; // Consider logging or improving the error handling here.
    }
  }
}
