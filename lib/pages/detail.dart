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
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                  boxShadow: [
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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,)),
                                const SizedBox(height: 8.0),
                                const Text(
                                  'Country ID:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Additional information about the place can go here.',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
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