import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/pages/settings.dart';
import 'package:travel_recommender/detail_cubit.dart';

class Detail extends StatefulWidget {
  final int countryId;
  final String name;

  const Detail({required this.countryId, required this.name, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int? _disabledButtonIndex;

  @override
  void initState() {
    context.read<DetailCubit>().loadData(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
            maxChildSize: 0.48,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
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
                      return Column(
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

                          Expanded(
                            child: ListView(
                              controller: scrollController,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.name, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,)),
                                      const SizedBox(height: 8.0),
                                      const Text('Cities', style: TextStyle(fontSize: 18.0)),
                                      const SizedBox(height: 8.0),
                                  
                                      Expanded(
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          spacing: 20, // Horizontal spacing between buttons
                                          runSpacing: 8, // Vertical spacing between buttons
                                          children: List.generate(
                                            state.cities.length, (index) {
                                              return ElevatedButton(
                                                onPressed: _disabledButtonIndex == index? null: () {
                                                  setState(() {
                                                    _disabledButtonIndex = index;
                                                  });
                                                },
                                                child: Text(state.cities[index]['name']),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ]
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