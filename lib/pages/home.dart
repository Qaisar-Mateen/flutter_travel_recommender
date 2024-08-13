import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/home_cubit.dart';
import 'package:travel_recommender/pages/detail.dart';
import 'package:travel_recommender/pages/login.dart';
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

      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(child: Icon(Icons.account_circle, size: 130)),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text("User ID: $id", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
                
            Padding(padding: const EdgeInsets.only(left: 25, top: 10),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            )),
              
            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(child: const Text('Logout'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false
                    );
                    context.read<HomeCubit>().logout();
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
               return const HomeSkeleton();
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
                    PopularDestinationSection(popular: state.popular, images: state.images,),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'For You',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ForYouSection(recommend: state.recommended, images: state.images,),
                  ],
                );
              }
              else if (state is HomeError) {
                return Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_outlined, color: Colors.red,),
                      Text(state.msg),
                    ],
                  ),
                );
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
  final List<Map<String, dynamic>> popular;
  final Map<String, Image> images;

  const PopularDestinationSection({required this.popular, required this.images, super.key});

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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(countryId: popular[index]['ID'], name: popular[index]['Country'], )));
                },
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
                            child: images[popular[index]['Country']],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.5, left: 5, right: 5),
                            child: Text(popular[index]["Country"], style: const TextStyle(fontSize: 16), maxLines: 1,),
                          ),
                        ],
                      ),
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
  final List<Map<String, dynamic>> recommend;
  final Map<String, Image> images;

  const ForYouSection({required this.recommend, required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recommend.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(countryId: recommend[index]['ID'], name: recommend[index]['Country'])));
            },
            child: Card(
              elevation: 10,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: images[recommend[index]['Country']],
                    ),
                  ),
            
                  SizedBox(
                    width: 155,
                    child: Text(recommend[index]['Country'], style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,)
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.inversePrimary,
              highlightColor: Theme.of(context).colorScheme.secondary,
              child: Container(
                width: 200,
                height: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 5, left: 4),
                child: Card(
                  elevation: 10,
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.inversePrimary,
                    highlightColor: Theme.of(context).colorScheme.secondary,
                    child: SizedBox(
                      width: 155,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: 100,
                                width: 150,
                                color: Colors.white,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 20,
                                  width: 100,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.inversePrimary,
              highlightColor: Theme.of(context).colorScheme.secondary,
              child: Container(
                width: 120,
                height: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
              child: Card(
                elevation: 10,
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.inversePrimary,
                  highlightColor: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 105,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}