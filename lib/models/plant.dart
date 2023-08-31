import 'dart:io';

class Plant {
  const Plant(
      {required this.id,
      required this.name,
      required this.roomLightLevel,
      required this.humidityLevel,
      required this.plantWateringNeeds,
      required this.image});

  final String id;
  final String name;
  final String roomLightLevel;
  final String humidityLevel;
  final String plantWateringNeeds;
  final String image;
}
