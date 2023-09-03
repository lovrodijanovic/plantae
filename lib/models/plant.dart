import 'dart:async';

class Plant {
  Plant(
      {required this.id,
      required this.name,
      required this.location,
      required this.image,
      required this.wateringInterval,
      required this.countdown});

  final String id;
  final String name;
  final String location;
  final String image;
  int wateringInterval; //in seconds
  int countdown;
  Timer? timer;
}
