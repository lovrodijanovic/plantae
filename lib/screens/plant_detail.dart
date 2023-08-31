import 'package:flutter/material.dart';
import 'package:plantae/models/plant.dart';

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key, required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(plant.name)),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(plant.name, textScaleFactor: 3),
              const SizedBox(
                height: 15,
              ),
              Text('Room light level: ${plant.roomLightLevel}',
                  textScaleFactor: 1.5),
              Text('Room humidity level: ${plant.humidityLevel}',
                  textScaleFactor: 1.5),
              Text('Plant watering needs: ${plant.plantWateringNeeds}',
                  textScaleFactor: 1.5),
              Image.network(plant.image)
            ],
          ),
        ));
  }
}
