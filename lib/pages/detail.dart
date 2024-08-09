import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/pages/settings.dart';
import 'package:travel_recommender/detail_cubit.dart';

class Detail extends StatelessWidget {
  final int countryId;
  final String name;

  const Detail({required this.countryId, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DetailCubit>().loadData(name);
    
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

      body: Stack(
        children: [
          DraggableScrollableSheet(
            initialChildSize: 0.11,
            minChildSize: 0.11,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: BlocBuilder<DetailCubit, DetailState>(
                  builder: (context, state) {
                    if (state is DetailLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DetailLoaded) {
                      return ListView(
                        controller: scrollController,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              height: 5.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,)),
                                const SizedBox(height: 8.0),
                                const Text('Cities', style: TextStyle(fontSize: 18.0)),
                                const SizedBox(height: 16.0),

                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(8),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    itemCount: state.cities.length,
                                    itemBuilder: (context, index) {
                                      return ElevatedButton(
                                        onPressed: () {
                                        },
                                        child: Text(state.cities[index]['name']),
                                      );
                                    }
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (state is DetailError) {
                      return Center(child: Text(state.msg));
                    } else {
                      return const Center(child: Text('Unknown state'));
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}