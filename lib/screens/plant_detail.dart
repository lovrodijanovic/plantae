import 'package:flutter/material.dart';
import 'package:plantae/models/plant.dart';
import 'package:plantae/widgets/timer-provider.dart';
import 'package:provider/provider.dart';

String formatCountdownTime(int seconds) {
  final days = seconds ~/ 86400;
  final hours = (seconds % 86400) ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainingSeconds = seconds % 60;

  return '$days days \n $hours hours \n $minutes minutes \n $remainingSeconds seconds';
}

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key, required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text(plant.name)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: <Widget>[
                    Consumer<TimerProvider>(
                        builder: (context, timerProvider, child) {
                      return Column(
                        children: [
                          Text(
                            'Next watering in: \n ${formatCountdownTime(plant.countdown)}',
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              timerProvider.startPlantTimer(plant);
                            },
                            child: const Text('Start Timer'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              timerProvider.stopPlantTimer(plant);
                            },
                            child: const Text('Stop Timer'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Restart the timer for the selected plant (replace plantToRestart with your plant instance)
                              Provider.of<TimerProvider>(context, listen: false)
                                  .restartPlantTimer(plant);
                            },
                            child: const Text('Restart Timer'),
                          ),
                          const Divider(),
                        ],
                      );
                    }),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text('Location: ${plant.location}', textScaleFactor: 1.5),
                const SizedBox(
                  height: 15,
                ),
                Image.network(plant.image)
              ],
            ),
          ),
        ));
  }
}
