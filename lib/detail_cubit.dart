import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommender/settings_cubit.dart';

abstract class DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  List<Map<String, dynamic>> cities;
  List<Map<String, dynamic>> places = [];

  DetailLoaded({required this.cities, List<Map<String, dynamic>>? place}) {
    if (place != null) {
      places = place;
    }
  }
}

class DetailError extends DetailState {
  String msg;

  DetailError({required this.msg});
}

class DetailCubit extends Cubit<DetailState> {
  final ServerCubit server;

  DetailCubit(this.server) : super(DetailLoading());

  updatePlaces(double lat, double long) async {
    if (state is! DetailLoaded) return;

    final url1 = "https://api.geoapify.com/v1/isoline?lat=$lat&lon=$long&type=time&mode=drive&range=900&apiKey=d76f029b27e04a9cb47a5356a7bf2a87";
    try {
      final response = await http.get(Uri.parse(url1));

      if (response.statusCode == 200) {
        final isoRespose = json.decode(response.body);
        final isoId = isoRespose['properties']['id'];
        final String url2 = "https://api.geoapify.com/v2/places?categories=accommodation.hotel,accommodation.hut,activity,sport,heritage,ski,tourism,leisure,natural,rental.bicycle,rental.ski,entertainment&conditions=named&filter=geometry:$isoId&limit=10&apiKey=d76f029b27e04a9cb47a5356a7bf2a87";
        
        final response1 = await http.get(Uri.parse(url2));

        if (response1.statusCode == 200) {
          final jsonPlaces = jsonDecode(response1.body);
         
          List<Map<String,dynamic>> placesList = [];

          for (var place in jsonPlaces['features']) {
            final name = place['properties']['name']?? 'unknown';
            final lat = place['geometry']['coordinates'][1];
            final long = place['geometry']['coordinates'][0];
            placesList.add({
              'name': name,
              'latlng': LatLng(lat, long),
            });
          }
          final currentState = state as DetailLoaded;
          emit(DetailLoaded(cities: currentState.cities, place: placesList));
        } else {
          if (kDebugMode) {
            print("ERROR: Places API CALL FAIL");
          }
        }
      } else {
        if (kDebugMode) {
          print("ERROR: ISOLINE API CALL FAIL");
        }
      }
    }
    catch(e) {
      if (kDebugMode) {
        print("$e");
      }
    }
  }

  loadData(String country) async {
    emit(DetailLoading());
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
          'name': item['name'], 'lat': item['lat'], 'long': item['lng']
        }).toList();

        emit(DetailLoaded(cities: city));
      } else {
        emit(DetailError(msg: "Couldn't Fetch Data From Server"));  
      }
    }
    catch (e) {
      emit(DetailError(msg: "$e"));
    }
  }
}