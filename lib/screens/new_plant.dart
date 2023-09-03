import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plantae/models/plant.dart';
import 'package:http/http.dart' as http;
import 'package:plantae/widgets/image_input.dart';

int secondsInADay = 86400;

class NewPlant extends StatefulWidget {
  const NewPlant({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewPlantState();
  }
}

class _NewPlantState extends State<NewPlant> {
  var locations = [
    "Kitchen",
    "Bedroom",
    "Living room",
    "Bathroom",
    "Attic",
    "Hallway",
    "Terrace"
  ];
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _location = '';
  var _wateringInterval = 1;
  int _countdown = 1;
  var _isSending = false;
  File? _selectedImage;
  String imageUrl = '';

  void _savePlant() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      if (_selectedImage == null) {
        return;
      }

      String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('plant-images');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      try {
        await referenceImageToUpload.putFile(File(_selectedImage!.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();
      } catch (error) {}

      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please upload an image')));
      }

      _formKey.currentState!.save();

      final url = Uri.https(
          'plantae-4f74f-default-rtdb.europe-west1.firebasedatabase.app',
          'plants.json');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _enteredName,
            'location': _location,
            'image': imageUrl,
            'wateringInterval': _wateringInterval,
            'countdown': _countdown
          }));

      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(Plant(
          id: resData['name'],
          name: _enteredName,
          location: _location,
          image: imageUrl,
          wateringInterval: _wateringInterval,
          countdown: _countdown));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Add a new plant')),
      body: SingleChildScrollView(
        child: Padding(
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
              TextFormField(
                decoration: const InputDecoration(
                    label: Text('How often do you water this plant in days')),
                initialValue: _wateringInterval.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Must be a valid, positive number.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _wateringInterval = int.parse(value!);
                  /** secondsInADay;*/
                  _countdown = _wateringInterval;
                },
              ),
              DropdownButtonFormField(
                items: [
                  for (final location in locations)
                    DropdownMenuItem(
                        value: location,
                        child: Row(children: [
                          Container(
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(location)
                        ]))
                ],
                onChanged: (value) {
                  setState(() {
                    _location = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Must enter value.';
                  }
                  return null;
                },
                decoration: const InputDecoration(label: Text('Location')),
              ),
              const SizedBox(
                height: 12,
              ),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text('Reset')),
                  ElevatedButton(
                      onPressed: _isSending ? null : _savePlant,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add Plant'))
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
