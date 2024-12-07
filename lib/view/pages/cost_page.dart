// import 'package:flutter/material.dart';
// import 'package:flutterapp_depd/data/response/status.dart';
// import 'package:flutterapp_depd/model/city.dart';
// import 'package:flutterapp_depd/model/model.dart';
// import 'package:flutterapp_depd/viewmodel/home_viewmodel.dart';
// import 'package:provider/provider.dart';

part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  HomeViewmodel homeViewmodel = HomeViewmodel();

  @override
  void initState() {
    homeViewmodel.getProvinceList();
    super.initState();
  }

  dynamic selectedProvinceOrigin;
  dynamic selectedCityOrigin;
  dynamic selectedProvinceDestination;
  dynamic selectedCityDestination;
  dynamic selectedCourier;
  final TextEditingController weightController = TextEditingController();
  String costResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Calculate Cost"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeViewmodel>(
        create: (BuildContext context) => homeViewmodel,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              // First Row: Courier Dropdown and Weight TextField
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedCourier,
                        hint: const Text('Select Courier'),
                        items: ['jne', 'pos', 'tiki']
                            .map<DropdownMenuItem<String>>((String courier) {
                          return DropdownMenuItem<String>(
                            value: courier,
                            child: Text(courier),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCourier = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Berat (gr)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Second Row: Origin Dropdowns
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildProvinceDropdown(
                        'Select Origin Province',
                        selectedProvinceOrigin,
                        (newValue) {
                          setState(() {
                            selectedProvinceOrigin = newValue;
                            selectedCityOrigin = null;
                            homeViewmodel
                                .getCityList(selectedProvinceOrigin.provinceId);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: _buildCityDropdown(
                        'Select Origin City',
                        selectedCityOrigin,
                        (newValue) {
                          setState(() {
                            selectedCityOrigin = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Third Row: Destination Dropdowns
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildProvinceDropdown(
                        'Select Destination Province',
                        selectedProvinceDestination,
                        (newValue) {
                          setState(() {
                            selectedProvinceDestination = newValue;
                            selectedCityDestination = null;
                            homeViewmodel.getCityList(
                                selectedProvinceDestination.provinceId);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: _buildCityDropdown(
                        'Select Destination City',
                        selectedCityDestination,
                        (newValue) {
                          setState(() {
                            selectedCityDestination = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Fourth Row: Calculate Button
              Flexible(
                flex: 1,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add calculate cost logic here
                      if (selectedProvinceOrigin != null &&
                          selectedCityOrigin != null &&
                          selectedProvinceDestination != null &&
                          selectedCityDestination != null &&
                          selectedCourier != null &&
                          weightController.text.isNotEmpty) {
                        double weight =
                            double.tryParse(weightController.text) ?? 0;
                        // Call the API or calculation logic here
                        _calculateCost(
                          selectedProvinceOrigin,
                          selectedCityOrigin,
                          selectedProvinceDestination,
                          selectedCityDestination,
                          selectedCourier,
                          weight,
                        );
                      } else {
                        setState(() {
                          costResult = "Please fill in all fields!";
                        });
                      }
                    },
                    child: const Text('Calculate Cost'),
                  ),
                ),
              ),
              // Fifth Row: Show Cost Result
              Flexible(
                flex: 1,
                child: Center(
                  child: Text(
                    costResult,
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ),
              ),
              // Sixth Row: Blank
              Flexible(
                flex: 5,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProvinceDropdown(
      String hint, dynamic selectedValue, ValueChanged<dynamic> onChanged) {
    return Consumer<HomeViewmodel>(builder: (context, value, _) {
      switch (value.provinceList.status) {
        case Status.loading:
          return const Center(child: CircularProgressIndicator());
        case Status.error:
          return Center(child: Text(value.provinceList.message.toString()));
        case Status.completed:
          return DropdownButton<Province>(
            isExpanded: true,
            value: selectedValue,
            hint: Text(hint),
            items: value.provinceList.data!
                .map<DropdownMenuItem<Province>>((Province province) {
              return DropdownMenuItem<Province>(
                value: province,
                child: Text('${province.province}'),
              );
            }).toList(),
            onChanged: onChanged,
          );
        default:
          return const SizedBox();
      }
    });
  }

  Widget _buildCityDropdown(
      String hint, dynamic selectedValue, ValueChanged<dynamic> onChanged) {
    return Consumer<HomeViewmodel>(
      builder: (context, value, _) {
        switch (value.cityList.status) {
          case Status.loading:
            return const Center(child: CircularProgressIndicator());
          case Status.error:
            return Center(child: Text(value.cityList.message.toString()));
          case Status.completed:
            return Expanded(
              // This ensures that the dropdown takes available space.
              child: DropdownButton<City>(
                isExpanded: true,
                value: selectedValue,
                hint: Text(hint),
                items: value.cityList.data!
                    .map<DropdownMenuItem<City>>((City city) {
                  return DropdownMenuItem<City>(
                    value: city,
                    child: Text(city.cityName ?? "Unknown City"),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  // The cost calculation logic
  void _calculateCost(
    dynamic originProvince,
    dynamic originCity,
    dynamic destinationProvince,
    dynamic destinationCity,
    dynamic courier,
    double weight,
  ) {
    // Implement the API call or cost calculation logic here
    // Example: Assuming a basic calculation logic for now
    double cost = weight *
        0.1; // Example cost logic (this should be replaced with the actual calculation)

    setState(() {
      costResult = "Estimated Cost: \$${cost.toStringAsFixed(2)}";
    });
  }
}
