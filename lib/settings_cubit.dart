import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.blueGrey.shade50,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 36, 34, 34),
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 47, 46, 46),
    primary: Colors.grey.shade200,
    secondary: const Color.fromARGB(255, 33, 33, 33),
    inversePrimary: Colors.grey.shade300
  )
);

class ThemeCubit extends Cubit<ThemeData> {
  SharedPreferences? _prefs;

  ThemeCubit() : super(lightTheme) {
    _init();
  }

  _init () async {
    await _initPrefs();
    emit(_getPreference());
  }

  toggleTheme() {
    _updatePreference();
    emit(isDark()? lightTheme:darkTheme);
  }

  bool isDark() => state.brightness == Brightness.dark;

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  _updatePreference() async {
    await _initPrefs();
    _prefs!.setBool('theme', isDark());
  }

  ThemeData _getPreference() {
    _initPrefs();
    bool isDarkMode = _prefs?.getBool('theme') ?? false;
    
    return isDarkMode? darkTheme : lightTheme;
  }
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