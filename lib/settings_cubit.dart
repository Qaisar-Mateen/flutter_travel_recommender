import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 54, 53, 53),
    primary: Colors.grey.shade600,
    secondary: const Color.fromARGB(255, 33, 33, 33),
    inversePrimary: Colors.grey.shade300
  )
);

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  toggleTheme() {emit(isDark()? lightTheme:darkTheme);}

  bool isDark() => state.brightness == Brightness.dark;
}


class ServerState {
  String ip;
  String port;
  String timeout;

  ServerState({required this.ip, required this.port, required this.timeout});
}

class ServerCubit extends Cubit<ServerState> {
  ServerCubit() : super(ServerState(ip: "192.168.1.9", port: "5000", timeout: "5"));
}