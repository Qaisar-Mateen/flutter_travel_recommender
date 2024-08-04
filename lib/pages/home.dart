import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/home_cubit.dart';
import 'package:travel_recommender/pages/settings.dart';

class Home extends StatelessWidget {
  final int id;
  const Home({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.fetchData(id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('H O M E'),
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
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const CircularProgressIndicator.adaptive();
              }
              if (state is HomeLoaded) {
                return Column(
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'For You',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ForYouSection(),
                  ],
                );
              }
              else if (state is HomeError) {
                return Center(child: Row(
                  children: [
                    const Icon(Icons.error_outline_outlined, color: Colors.red,),
                    Text(state.msg),
                  ],
                ));
              }
              return Container();
            }
          ),
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