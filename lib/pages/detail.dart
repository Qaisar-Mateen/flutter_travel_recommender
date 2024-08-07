import 'package:flutter/material.dart';
import 'package:travel_recommender/pages/settings.dart';

class Detail extends StatelessWidget {
  final int countryId;
  final String name;

  const Detail({required this.countryId, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
        ],
      ),
    );
  }
}