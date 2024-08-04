import 'package:flutter/material.dart';
import 'package:travel_recommender/pages/settings.dart';

class Home extends StatelessWidget {
  final int id;
  const Home({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Popular Destinations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            PopularDestinationSection(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'For You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ForYouSection(),
          ],
        ),
      ),
    );
  }
}

class PopularDestinationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              width: 150,
              child: Column(
                children: [
                  Image.network(
                    'https://via.placeholder.com/150',
                    height: 100,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Destination $index'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ForYouSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.network(
              'https://via.placeholder.com/150',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text('Recommendation $index'),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(id: 1),
  ));
}