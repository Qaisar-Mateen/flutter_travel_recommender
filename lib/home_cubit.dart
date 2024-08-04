import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/settings_cubit.dart';


abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  List<String>? popular;
  List<String>? recommended;

  HomeLoaded({required this.popular, required this.recommended});
}

class HomeError extends HomeState {
  final String msg;

  HomeError({required this.msg});
}


class HomeCubit extends Cubit<HomeState> {
  final ServerCubit server;

  HomeCubit({required this.server}) : super(HomeLoading());

  fetchData(int id) async {
    try{
      final response1 = await http.get(
        Uri.parse(
          '''http://${server.state.ip}:${server.state.port}/recommend?popular'''
        )
      ).timeout(Duration(seconds: int.parse(server.state.timeout)));

      final response2 = await http.get(
        Uri.parse(
          '''http://${server.state.ip}:${server.state.port}/recommend?userId=$id'''
        )
      ).timeout(Duration(seconds: int.parse(server.state.timeout)));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final List<dynamic> popularJson = jsonDecode(response1.body);
        final List<dynamic> recommendedJson = jsonDecode(response2.body);

        final List<String> popular = popularJson.map((item) => item['Country'] as String).toList();
        final List<String> recommended = recommendedJson.map((item) => item['Country'] as String).toList();
 
        emit(HomeLoaded(popular: popular, recommended: recommended));
      }

      else {
        emit(HomeError(msg: "Couldn't Fetch Data From Server"));
      }

    }

    catch(e) {
      emit(HomeError(msg: "Couldn't Communicate with Server"));
    }
  }

}