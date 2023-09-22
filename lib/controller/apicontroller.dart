import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';

import '../helper/api_constants.dart';
import '../models/weather_data_model.dart';
import '../services/api_services.dart';

class ApiController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }



  @override
  void dispose() {
    super.dispose();
    controller;
  }

  RxBool isTyping = false.obs;
  RxBool isCityFound = false.obs;
  RxString city = "kathmandu".obs;

  RxString url =
      "https://api.openweathermap.org/data/2.5/weather?q=Kathmandu&units=metric&appid=be7ee777fd9edabedc1e0465133be3a8".obs;

  Rx<TextEditingController> controller = TextEditingController().obs;






  ///This method will call when user search any city
  void search() {
    url.value =
        "https://api.openweathermap.org/data/2.5/weather?q=${city.value}&units=metric&appid=be7ee777fd9edabedc1e0465133be3a8";
    api = url.value;

    fetchData();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }






  ///It will call when user change something in textfield where he's searching city.
  void onchangedController(String searchContent) {
    if (searchContent.isNotEmpty) {
      city.value = searchContent;
      isTyping.value = true;
    } else {
      isTyping.value = false;
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }







  ///Here it will observer call of weather modek and fetch the data.
  Rx<WeatherModel> weatherData = WeatherModel().obs;
  RxBool isloading = true.obs;
  Future<void> fetchData() async {
    isloading.value = true;
    isCityFound = false.obs;
    weatherData.value = await API().getData();
    if (weatherData.value.cod == "404") {
      isCityFound.value = false;
      isloading.value = false;
    } else {
      isCityFound.value = true;
    }

    isloading.value = false;
  }
}
