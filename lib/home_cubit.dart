import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/settings_cubit.dart';


abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  List<Map<String, dynamic>> popular;
  List<Map<String, dynamic>> recommended;
  Map<String, Image> images;

  HomeLoaded({required this.popular, required this.recommended, required this.images});
}

class HomeError extends HomeState {
  final String msg;

  HomeError({required this.msg});
}


class HomeCubit extends Cubit<HomeState> {
  final ServerCubit server;

  HomeCubit({required this.server}) : super(HomeLoading());

  fetchData(int id) async {
    //await Future.delayed(const Duration(seconds: 10));
    emit(HomeLoading());
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
            'Code': item['Country Code'] as String?,
          }).toList();

        final List<Map<String, dynamic>> recommended = recommendedJson.map((item) => {
          'ID': item['ID'] as int,
          'Country': item['Country'] as String,
          'Code': item['Country Code'] as String?,
        }).toList();

        final Map<String, Image> countryFlags = {};

        for (var item in recommended) {
          final countryCode = item['Code'];
          final countryName = item['Country'];

          if (countryCode != null) {
            final flagUrl = 'https://flagcdn.com/w320/${countryCode.toLowerCase()}.png';
            final flagResponse = await http.get(Uri.parse(flagUrl));

            if (flagResponse.statusCode == 200) {
              countryFlags[countryName] = Image.network(flagUrl,height:100,width:150,fit:BoxFit.cover);
            } else {
              countryFlags[countryName] = Image.network('https://via.placeholder.com/150',height:100,width:150,fit:BoxFit.cover);
            }
          } else {
            countryFlags[countryName] = Image.network('https://via.placeholder.com/150',height:100,width:150,fit:BoxFit.cover);
          }
        }

        emit(HomeLoaded(popular: popular, recommended: recommended, images: countryFlags));
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