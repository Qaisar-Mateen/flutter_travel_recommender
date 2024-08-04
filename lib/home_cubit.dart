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
          '''http://${server.state.ip}:${server.state.port}/recommender?userId=$id'''
        )
      ).timeout(Duration(seconds: int.parse(server.state.timeout)));

      final response2 = await http.get(
        Uri.parse(
          '''http://${server.state.ip}:${server.state.port}/recommender?userId=$id'''
        )
      ).timeout(Duration(seconds: int.parse(server.state.timeout)));


      if (response1.statusCode == 200 && response2.statusCode == 200){
        emit(HomeLoaded(popular: [], recommended: []));
      }

    }
    catch(e) {
      emit(HomeError(msg: "Couldn't Fetch Data From Server"));
    }
  }

}