import 'dart:async';

class Plant {
  Plant(
      {required this.id,
      required this.name,
      required this.roomLightLevel,
      required this.humidityLevel,
      required this.plantWateringNeeds,
      required this.image,
      required this.wateringInterval,
      required this.countdown});

  final String id;
  final String name;
  final String roomLightLevel;
  final String humidityLevel;
  final String plantWateringNeeds;
  final String image;
  int wateringInterval; //in seconds
  int countdown;
  Timer? timer;
}
