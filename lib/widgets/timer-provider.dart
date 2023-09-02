import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:plantae/models/plant.dart';

class TimerProvider with ChangeNotifier {
  void startPlantTimer(Plant plant) {
    plant.timer?.cancel();
    plant.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (plant.countdown > 0) {
        plant.countdown--;
        notifyListeners();
      } else {
        // The timer has reached zero, you can perform watering action or any other desired action here.
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void stopPlantTimer(Plant plant) {
    plant.timer?.cancel();
    notifyListeners();
  }

  void restartPlantTimer(Plant plant) {
    stopPlantTimer(plant);
    plant.countdown = plant.wateringInterval;
    startPlantTimer(plant);
  }
}
