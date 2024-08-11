import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/settings_cubit.dart';


abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  List<Map<String, dynamic>> popular;
  List<Map<String, dynamic>> recommended;

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
    await Future.delayed(const Duration(seconds: 10));
    try{
      final response1 = server.state.local? await http.get(
        Uri.parse(
          '''http://${server.state.ip}:${server.state.port}/recommend?popular'''
        )
      ).timeout(Duration(seconds: int.parse(server.state.timeout))):
      await http.get(Uri.parse(
        'https://qaisarmateen.pythonanywhere.com/recommend?popular'
      ));

      final response2 = server.state.local? await http.get(
        Uri.parse(
          '''http://${server.state.ip}:${server.state.port}/recommend?userId=$id'''
        )
      ).timeout(Duration(seconds: int.parse(server.state.timeout))):
      await http.get(Uri.parse(
        'https://qaisarmateen.pythonanywhere.com/recommend?userId=$id'
      ));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final List<dynamic> popularJson = jsonDecode(response1.body);
        final List<dynamic> recommendedJson = jsonDecode(response2.body);
        final List<Map<String, dynamic>> popular = popularJson.map((item) => {
            'ID': item['ID'] as int,
            'Country': item['Country'] as String,
          }).toList();

        final List<Map<String, dynamic>> recommended = recommendedJson.map((item) => {
          'ID': item['ID'] as int,
          'Country': item['Country'] as String,
        }).toList();

        emit(HomeLoaded(popular: popular, recommended: recommended));
      }

      else {
        emit(HomeError(msg: "Couldn't Fetch Data From Server"));
      }
    }

    catch(e) {
      if (kDebugMode) {
        print(e);
      }
      emit(HomeError(msg: "Couldn't Communicate with Server"));
    }
  }

  logout() {
    emit(HomeLoading());
  }

}