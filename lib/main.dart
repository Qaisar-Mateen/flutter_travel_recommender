import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/pages/login.dart';
import 'package:travel_recommender/settings_cubit.dart';
import 'package:travel_recommender/home_cubit.dart';
import 'package:travel_recommender/detail_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ServerCubit()),
        BlocProvider(create: (context) => HomeCubit(server: context.read<ServerCubit>())),
        BlocProvider(create: (context) => DetailCubit(context.read<ServerCubit>()))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Travel Recommender',
      theme: context.watch<ThemeCubit>().state,
      home: const Login(),
    );
  }
}