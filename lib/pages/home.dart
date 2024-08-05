import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/home_cubit.dart';
import 'package:travel_recommender/pages/drawer.dart';
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

      drawer: MyDrawer(id: id),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
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
                    PopularDestinationSection(popular: state.popular),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'For You',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ForYouSection(recommend: state.recommended),
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
  final List<String> popular;

  const PopularDestinationSection({required this.popular, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black,
              Colors.transparent,
            ],
            stops: [0.0, 0.05, 0.95, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: popular.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15, right: 5, left: 4),
              child: Card(
                elevation: 10,
                child: SizedBox(
                  width: 155,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://via.placeholder.com/150',
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.5, left: 5, right: 5),
                          child: Text(popular[index], style: const TextStyle(fontSize: 16), maxLines: 1,),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ForYouSection extends StatelessWidget {
  final List<String> recommend;

  const ForYouSection({required this.recommend, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recommend.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
          child: Card(
            elevation: 10,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://via.placeholder.com/150',
                      height: 100,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          
                SizedBox(
                  width: 155,
                  child: Text(recommend[index], style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,)
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}