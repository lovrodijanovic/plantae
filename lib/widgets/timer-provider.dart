import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:plantae/models/plant.dart';

class TimerProvider with ChangeNotifier {
  void updatePlantTimer(String plantId, int countdownValue) {
    final DatabaseReference plantRef = FirebaseDatabase(
            databaseURL:
                'https://plantae-4f74f-default-rtdb.europe-west1.firebasedatabase.app/')
        .reference()
        .child('plants')
        .child(plantId);
    plantRef.update({
      'countdown': countdownValue,
    });
  }

  void startPlantTimer(Plant plant) {
    plant.timer?.cancel();
    plant.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (plant.countdown > 0) {
        plant.countdown--;
        notifyListeners();
      } else {
        updatePlantTimer(plant.id, 0);
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
    updatePlantTimer(plant.id, plant.wateringInterval);
    stopPlantTimer(plant);
    plant.countdown = plant.wateringInterval;
    startPlantTimer(plant);
  }
}
