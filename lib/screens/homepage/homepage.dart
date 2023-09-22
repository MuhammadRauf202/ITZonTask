import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../controller/apicontroller.dart';
import '../../controller/dark_mode_controller.dart';
import '../../widget/reuseable_row.dart';
import '../../widget/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var darkModeController = Get.find<DarkModeController>();
  var controller = Get.put(ApiController());
  String iconBaseUrl = "https://openweathermap.org/img/w/";

  DateTime dateTime = DateTime.now();
  String formattedDate = "";



  @override
  void initState() {
    formattedDate = DateFormat('E dd, yyyy').format(dateTime);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.grey[200],
        body: homeScreenBody());
  }

  ///Home Screen Body Widget
  Widget homeScreenBody() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => controller.fetchData(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                weatherHeadingAndThemeSwitch(),
                const SizedBox(height: 40),
                TopSearchBar(),
                const SizedBox(height: 30),
                observerOfTheWeather()
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///This is the ui of the top appbar of the home screen where we show date and Theme and switch
  Widget weatherHeadingAndThemeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weather",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "$formattedDate",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.grey[200],
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
        Obx(
          () => Switch(
              value: darkModeController.isDark.value,
              onChanged: (value) => darkModeController.onChange(value)),
        )
      ],
    );
  }

  ///These are the observers of the weather data
  Widget observerOfTheWeather() {
    return Obx(
      () => controller.isloading.value
          ? const Center(child: CupertinoActivityIndicator(radius: 16))
          : controller.isCityFound.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.weatherData.value.name.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Image.network(
                              "$iconBaseUrl${controller.weatherData.value.weather![0].icon}.png",
                              height: MediaQuery.of(context).size.height * 0.2,
                              fit: BoxFit.cover),
                          Text(
                              controller.weatherData.value.main!.temp
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w700)),
                          Text(
                              controller.weatherData.value.weather![0].main
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    Obx(
                      () => Column(
                        children: [
                          ReuseableRow(
                              title: "Humidity",
                              info: controller.weatherData.value.main!.humidity
                                  .toString()),
                          ReuseableRow(
                              title: "Pressure",
                              info: controller.weatherData.value.main!.pressure
                                  .toString()),
                          ReuseableRow(
                              title: "Windspeed",
                              info: controller.weatherData.value.wind!.speed
                                  .toString()),
                        ],
                      ),
                    )
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/images/notFound.json",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.5),
                      Text(
                        "Oops",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        "City Not Found",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
    );
  }
}
