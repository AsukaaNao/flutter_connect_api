import 'package:flutter/material.dart';
import 'package:flutterapp_depd/data/response/api_response.dart';
import 'package:flutterapp_depd/model/city.dart';
import 'package:flutterapp_depd/model/costs/costresponse.dart';
import 'package:flutterapp_depd/model/model.dart';
import 'package:flutterapp_depd/repository/home_repository.dart';

class HomeViewmodel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  // Province and City lists for origin and destination
  ApiResponse<List<Province>> provinceListOrigin = ApiResponse.loading();
  ApiResponse<List<City>> cityListOrigin = ApiResponse.loading();
  ApiResponse<List<Province>> provinceListDestination = ApiResponse.loading();
  ApiResponse<List<City>> cityListDestination = ApiResponse.loading();

  // Cost result
  ApiResponse<CostResponse> costResult = ApiResponse.loading();

  // Selected Province and City for origin and destination
  Province? selectedProvinceOrigin;
  City? selectedCityOrigin;
  Province? selectedProvinceDestination;
  City? selectedCityDestination;

  // Setters for API responses
  setProvinceListOrigin(ApiResponse<List<Province>> response) {
    provinceListOrigin = response;
    notifyListeners();
  }

  setCityListOrigin(ApiResponse<List<City>> response) {
    cityListOrigin = response;
    notifyListeners();
  }

  setProvinceListDestination(ApiResponse<List<Province>> response) {
    provinceListDestination = response;
    notifyListeners();
  }

  setCityListDestination(ApiResponse<List<City>> response) {
    cityListDestination = response;
    notifyListeners();
  }

  setCostResult(ApiResponse<CostResponse> response) {
    costResult = response;
    notifyListeners();
  }

  // Fetch list of provinces for origin
  Future<void> getProvinceListOrigin() async {
    setProvinceListOrigin(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceListOrigin(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceListOrigin(ApiResponse.error(error.toString()));
    });
  }

  // Fetch list of provinces for destination
  Future<void> getProvinceListDestination() async {
    setProvinceListDestination(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceListDestination(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceListDestination(ApiResponse.error(error.toString()));
    });
  }

  // Fetch list of cities for the origin province
  Future<void> getCityListOrigin(var provinceId) async {
    setCityListOrigin(ApiResponse.loading());
    _homeRepo.fetchCityList(provinceId).then((value) {
      setCityListOrigin(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityListOrigin(ApiResponse.error(error.toString()));
    });
  }

  // Fetch list of cities for the destination province
  Future<void> getCityListDestination(var provinceId) async {
    setCityListDestination(ApiResponse.loading());
    _homeRepo.fetchCityList(provinceId).then((value) {
      setCityListDestination(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityListDestination(ApiResponse.error(error.toString()));
    });
  }

  // Calculate cost based on origin, destination, weight, and courier
  Future<void> calculateCost({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    setCostResult(ApiResponse.loading());
    _homeRepo
        .calculateCost(
      origin: origin,
      destination: destination,
      weight: weight,
      courier: courier,
    )
        .then((value) {
      setCostResult(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCostResult(ApiResponse.error(error.toString()));
    });
  }
}
