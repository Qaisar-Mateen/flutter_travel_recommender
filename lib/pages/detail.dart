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

      bottomSheet: BottomSheet(
        elevation: 10,
        onClosing: () {},
        builder:  (BuildContext context) {
          return BlocBuilder<DetailCubit, DetailState>(
            builder: (context, state) {
              if (state is DetailLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DetailLoaded) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "fuck you",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Country ID:',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Additional information about the place can go here.',
                        style:TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is DetailError) {
                return Center(child: Text(state.msg));
              } else {
                return const Center(child: Text('Unknown state'));
              }
            }
          );
        }
      ),
    );
  }
}