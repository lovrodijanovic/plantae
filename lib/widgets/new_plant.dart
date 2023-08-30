import 'package:flutter/material.dart';
import 'package:plantae/models/plant.dart';

class NewPlant extends StatefulWidget {
  const NewPlant({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewPlantState();
  }
}

class _NewPlantState extends State<NewPlant> {
  var intensities = ['Low', 'Medium', 'High'];
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _roomLightLevel;
  var _humidityLevel;
  var _plantWateringNeeds;

  void _savePlant() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(Plant(
          id: DateTime.now().toString(),
          name: _enteredName,
          roomLightLevel: _roomLightLevel,
          humidityLevel: _humidityLevel,
          plantWateringNeeds: _plantWateringNeeds));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new plant')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(label: Text('Name')),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length == 1 ||
                    value.trim().length > 50) {
                  return 'Must be between 1 and 50 characters.';
                }
                return null;
              },
              onSaved: (value) {
                _enteredName = value!;
              },
            ),
            DropdownButtonFormField(
              items: [
                for (final intensity in intensities)
                  DropdownMenuItem(
                      value: intensity,
                      child: Row(children: [
                        Container(
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(intensity)
                      ]))
              ],
              onChanged: (value) {
                setState(() {
                  _roomLightLevel = value!;
                });
              },
              decoration:
                  const InputDecoration(label: Text('Room light level')),
            ),
            DropdownButtonFormField(
              items: [
                for (final intensity in intensities)
                  DropdownMenuItem(
                      value: intensity,
                      child: Row(children: [
                        Container(
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(intensity)
                      ]))
              ],
              onChanged: (value) {
                setState(() {
                  _humidityLevel = value!;
                });
              },
              decoration:
                  const InputDecoration(label: Text('Room humidity level')),
            ),
            DropdownButtonFormField(
              items: [
                for (final intensity in intensities)
                  DropdownMenuItem(
                      value: intensity,
                      child: Row(children: [
                        Container(
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(intensity)
                      ]))
              ],
              onChanged: (value) {
                setState(() {
                  _plantWateringNeeds = value!;
                });
              },
              decoration:
                  const InputDecoration(label: Text('Plant watering needs')),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset')),
                ElevatedButton(
                    onPressed: _savePlant, child: const Text('Add Plant'))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
