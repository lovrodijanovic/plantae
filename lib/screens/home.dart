import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:plantae/models/plant.dart';
import 'package:plantae/screens/plant_detail.dart';
import 'package:plantae/screens/new_plant.dart';
import 'package:http/http.dart' as http;
import 'package:plantae/widgets/timer-provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Plant> _plants = [];
  var _isLoading = true;
  String? _error;

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    await fcm.subscribeToTopic("plant");
  }

  @override
  void initState() {
    super.initState();

    _loadPlants();

    setupPushNotifications();
  }

  void _loadPlants() async {
    final url = Uri.https(
        'plantae-4f74f-default-rtdb.europe-west1.firebasedatabase.app',
        'plants.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data. Try again later.';
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);

    final List<Plant> loadedPlants = [];

    for (final plant in listData.entries) {
      loadedPlants.add(Plant(
          id: plant.key,
          name: plant.value['name'],
          location: plant.value['location'],
          image: plant.value['image'],
          wateringInterval: plant.value['wateringInterval'],
          countdown: plant.value['countdown']));
    }

    setState(() {
      _plants = loadedPlants;
      _isLoading = false;
    });
  }

  void _addPlant() async {
    final newPlant = await Navigator.of(context)
        .push<Plant>(MaterialPageRoute(builder: (ctx) => const NewPlant()));

    if (newPlant == null) {
      return;
    }

    setState(() {
      _plants.add(newPlant);
    });
  }

  void _removePlant(Plant plant) async {
    final index = _plants.indexOf(plant);

    setState(() {
      _plants.remove(plant);
    });

    final url = Uri.https(
        'plantae-4f74f-default-rtdb.europe-west1.firebasedatabase.app',
        'plants/${plant.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _plants.insert(index, plant);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No plants added yet.'));

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_plants.isNotEmpty) {
      content = ListView.builder(
        itemCount: _plants.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removePlant(_plants[index]);
          },
          key: ValueKey(_plants[index].id),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => PlantDetailScreen(plant: _plants[index])));
            },
            visualDensity: const VisualDensity(vertical: 4),
            title: Text(_plants[index].name),
            leading: CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  _plants[index].image,
                )),
            trailing: Consumer<TimerProvider>(
                builder: (context, timerProvider, child) {
              if (_plants[index].countdown <= 0) {
                return const Text("This plant needs watering!");
              } else {
                return Text(
                  'Next watering in: \n ${formatCountdownTime(_plants[index].countdown)}',
                );
              }
            }),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Plantae'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                )),
            IconButton(
                onPressed: _addPlant,
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: content,
        ));
  }
}
