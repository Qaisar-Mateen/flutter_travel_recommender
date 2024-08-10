import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/settings_cubit.dart';

abstract class DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  List<Map<String, dynamic>> cities;

  DetailLoaded({required this.cities});
}

class DetailError extends DetailState {
  String msg;

  DetailError({required this.msg});
}

class DetailCubit extends Cubit<DetailState> {
  final ServerCubit server;

  DetailCubit(this.server) : super(DetailLoading());

  loadData(String country) async {
    try {
      final response = await http.get(server.state.local?
        Uri.parse(
        '''http://${server.state.ip}:${server.state.port}/recommend/cities?country=$country'''
        ):
        Uri.parse(
          '''https://qaisarmateen.pythonanywhere.com/recommend/cities?country=$country'''
        )
      );

      if(response.statusCode == 200){
        final List<dynamic> cityJson = jsonDecode(response.body);

        final List<Map<String, dynamic>> city = cityJson.map((item) => {
          'name': item['name'], 'latitude': item['lat'], 'longitude': item['lng']
        }).toList();

        emit(DetailLoaded(cities: city));
      } else {
        emit(DetailError(msg: "Couldn't Fetch Data From Server"));  
      }
    }
    catch (e) {
      emit(DetailError(msg: "e"));
    }
  }
}