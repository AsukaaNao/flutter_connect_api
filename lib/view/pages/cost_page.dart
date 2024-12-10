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

  bool isLoading = false; // Loading state

  @override
  void initState() {
    homeViewmodel.getProvinceListOrigin();
    homeViewmodel.getProvinceListDestination();
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Courier and Weight Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Courier Dropdown
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Courier",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCourier,
                            hint: const Text('Select Courier'),
                            items: [
                              'jne',
                              'pos',
                              'tiki'
                            ].map<DropdownMenuItem<String>>((String courier) {
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
                        ],
                      ),
                    ),
                    const SizedBox(
                        width: 16), // Space between dropdown and input

                    // Weight Input
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Weight (in grams)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter weight',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Origin Section
                const Text(
                  "Origin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child:
                          Consumer<HomeViewmodel>(builder: (context, value, _) {
                        switch (value.provinceListOrigin.status) {
                          case Status.loading:
                            return const Center(
                                child: CircularProgressIndicator());
                          case Status.error:
                            return Center(
                                child: Text(value.provinceListOrigin.message
                                    .toString()));
                          case Status.completed:
                            return DropdownButton<Province>(
                              isExpanded: true,
                              value: selectedProvinceOrigin,
                              hint: const Text('Select Origin Province'),
                              items: value.provinceListOrigin.data!
                                  .map<DropdownMenuItem<Province>>(
                                      (Province province) {
                                return DropdownMenuItem<Province>(
                                  value: province,
                                  child: Text(
                                      province.province ?? "Unknown Province"),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedProvinceOrigin = newValue;
                                  selectedCityOrigin =
                                      null; // Reset selected city when province changes
                                  if (newValue != null) {
                                    // Fetch the cities for the selected province
                                    homeViewmodel
                                        .getCityListOrigin(newValue.provinceId);
                                  }
                                });
                              },
                            );
                          default:
                            return const SizedBox();
                        }
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Consumer<HomeViewmodel>(
                        builder: (context, value, _) {
                          switch (value.cityListOrigin.status) {
                            case Status.loading:
                              return const Center(
                                  child: CircularProgressIndicator());
                            case Status.error:
                              return Center(
                                  child: Text(
                                      value.cityListOrigin.message.toString()));
                            case Status.completed:
                              return DropdownButton<City>(
                                isExpanded: true,
                                value: selectedCityOrigin,
                                hint: const Text('Select Origin City'),
                                items: value.cityListOrigin.data!
                                    .map<DropdownMenuItem<City>>((City city) {
                                  return DropdownMenuItem<City>(
                                    value: city,
                                    child:
                                        Text(city.cityName ?? "Unknown City"),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCityOrigin = newValue;
                                  });
                                },
                              );
                            default:
                              return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Destination Section
                const Text(
                  "Destination",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child:
                          Consumer<HomeViewmodel>(builder: (context, value, _) {
                        switch (value.provinceListDestination.status) {
                          case Status.loading:
                            return const Center(
                                child: CircularProgressIndicator());
                          case Status.error:
                            return Center(
                                child: Text(value
                                    .provinceListDestination.message
                                    .toString()));
                          case Status.completed:
                            return DropdownButton<Province>(
                              isExpanded: true,
                              value: selectedProvinceDestination,
                              hint: const Text('Select Destination Province'),
                              items: value.provinceListDestination.data!
                                  .map<DropdownMenuItem<Province>>(
                                      (Province province) {
                                return DropdownMenuItem<Province>(
                                  value: province,
                                  child: Text(
                                      province.province ?? "Unknown Province"),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedProvinceDestination = newValue;
                                  selectedCityDestination =
                                      null; // Reset selected city when province changes
                                  if (newValue != null) {
                                    // Fetch the cities for the selected province
                                    homeViewmodel.getCityListDestination(
                                        newValue.provinceId);
                                  }
                                });
                              },
                            );
                          default:
                            return const SizedBox();
                        }
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Consumer<HomeViewmodel>(
                        builder: (context, value, _) {
                          switch (value.cityListDestination.status) {
                            case Status.loading:
                              return const Center(
                                  child: CircularProgressIndicator());
                            case Status.error:
                              return Center(
                                  child: Text(value.cityListDestination.message
                                      .toString()));
                            case Status.completed:
                              return DropdownButton<City>(
                                isExpanded: true,
                                value: selectedCityDestination,
                                hint: const Text('Select Destination City'),
                                items: value.cityListDestination.data!
                                    .map<DropdownMenuItem<City>>((City city) {
                                  return DropdownMenuItem<City>(
                                    value: city,
                                    child:
                                        Text(city.cityName ?? "Unknown City"),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCityDestination = newValue;
                                  });
                                },
                              );
                            default:
                              return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Calculate Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedProvinceOrigin != null &&
                          selectedCityOrigin != null &&
                          selectedProvinceDestination != null &&
                          selectedCityDestination != null &&
                          selectedCourier != null &&
                          weightController.text.isNotEmpty) {
                        double weight =
                            double.tryParse(weightController.text) ?? 0;
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
                const SizedBox(height: 24),

                // Cost Result
                Consumer<HomeViewmodel>(
                  builder: (context, viewModel, _) {
                    switch (viewModel.costResult.status) {
                      case Status.loading:
                        return Center(
                          // child: CircularProgressIndicator(),
                          child: isLoading
                              ? CircularProgressIndicator() // Loading state
                              : Text(
                                  costResult.isEmpty
                                      ? "No data available." // Default message
                                      : costResult, // Display result or error
                                  style: TextStyle(fontSize: 16),
                                ),
                        );
                      case Status.error:
                        return Center(
                          child: Text(
                            "Error: ${viewModel.costResult.message}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      case Status.completed:
                        final costResponse =
                            viewModel.costResult.data as CostResponse?;
                        if (costResponse == null ||
                            costResponse.costs == null ||
                            costResponse.costs!.isEmpty) {
                          return const Center(
                            child: Text("No cost data available."),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: costResponse.costs!.length,
                          itemBuilder: (context, index) {
                            final costs = costResponse.costs![index];
                            return ExpansionTile(
                              leading: const Icon(Icons.local_shipping,
                                  color: Colors.blue),
                              title: Text(
                                  "Service: ${costs.service ?? 'Unknown'}"),
                              subtitle: Text(
                                  "Description: ${costs.description ?? 'N/A'}"),
                              children: costs.cost?.map((cost) {
                                    return ListTile(
                                      title: Text(
                                        "Cost: \Rp. ${cost.value?.toStringAsFixed(2) ?? 'N/A'}",
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Estimated Delivery: ${cost.etd.toString().toLowerCase().contains("hari") ? cost.etd.toString().toLowerCase() : cost.etd.toString().toLowerCase() + " hari"}"),
                                          if (cost.note != null &&
                                              cost.note!.isNotEmpty)
                                            Text("Note: ${cost.note}"),
                                        ],
                                      ),
                                    );
                                  }).toList() ??
                                  [],
                            );
                          },
                        );
                      default:
                        return const SizedBox();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calculateCost(
    dynamic originProvince,
    dynamic originCity,
    dynamic destinationProvince,
    dynamic destinationCity,
    dynamic courier,
    double weight,
  ) async {
    if (originCity != null &&
        destinationCity != null &&
        courier.isNotEmpty &&
        weight > 0) {
      String origin = originCity.cityId.toString();
      String destination = destinationCity.cityId.toString();

      await homeViewmodel.calculateCost(
        origin: origin,
        destination: destination,
        weight: weight.toInt(),
        courier: courier,
      );
    } else {
      setState(() {
        costResult = "Please fill in all fields!";
        isLoading = true;
      });
    }

    setState(() {
      isLoading = false; // Reset loading state
      costResult =
          "Cost calculated successfully! Please wait"; // Example result
    });
  }
}
