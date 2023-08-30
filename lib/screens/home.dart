import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantae/models/plant.dart';
import 'package:plantae/widgets/new_plant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Plant> _plants = [];

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

  void _removePlant(Plant plant) {
    setState(() {
      _plants.remove(plant);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No plants added yet.'));

    if (_plants.isNotEmpty) {
      content = ListView.builder(
        itemCount: _plants.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removePlant(_plants[index]);
          },
          key: ValueKey(_plants[index].id),
          child: ListTile(
            title: Text(_plants[index].name),
            leading: Container(
              width: 24,
              height: 24,
            ),
            trailing: Text(
                "Room light level: ${_plants[index].roomLightLevel}\nHumidity level: ${_plants[index].humidityLevel}\nPlant watering needs: ${_plants[index].plantWateringNeeds}"),
          ),
        ),
      );
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
        body: content);
  }
}
