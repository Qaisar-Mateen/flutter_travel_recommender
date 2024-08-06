import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey.shade200,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade200,
    inversePrimary: Colors.grey.shade300,
    scrim: const Color.fromARGB(255, 57, 192, 255)
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 5,
      backgroundColor: const Color.fromARGB(255, 57, 192, 255),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(
      color: Colors.white
    ),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    elevation: 10,
    shape: StadiumBorder(),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 36, 34, 34),
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 47, 46, 46),
    primary: Colors.grey.shade200,
    secondary: const Color.fromARGB(255, 45, 43, 43),
    inversePrimary: const Color.fromARGB(255, 78, 75, 75),
    scrim: Colors.blue,
  ),
  applyElevationOverlayColor: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 5,
      backgroundColor: Colors.blue,
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(
      color: Colors.white
    ),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    elevation: 10,
    shape: StadiumBorder(),
  ),
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
  String? _ip;
  String? _port;
  String? _timeout;
  SharedPreferences? _pref;

  ServerState._internal({String? iP, String? porT, String? timeouT});

  //to wait for async function before emitting state
  static Future<ServerState> create({String? iP, String? porT, String? timeouT}) async {
    var state = ServerState._internal(iP: iP, porT: porT, timeouT: timeouT);
    await state._loadPref();
    return state;
  }

  _initPref() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  _loadPref() async {
    await _initPref();
    ip = _pref!.getString('ip') ?? '192.168.1.9';
    port = _pref!.getString('port') ?? '5000';
    timeout = _pref!.getString('timeout') ?? '5';
  }

  _updatePref() async {
    await _initPref();
    _pref!.setString('ip', ip);
    _pref!.setString('port', port);
    _pref!.setString('timeout', timeout);
  }

  String get ip => (_ip != null)? _ip! : "192.168.1.5";
  String get port =>(_port != null)? _port! : "5000";
  String get timeout => (_timeout != null)? _timeout! : "5";

  bool _isValidIp(String? ip) {
    if (ip == null) return false;
    final regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (!regex.hasMatch(ip)) return false;

    return ip.split('.').every((segment) {
      final number = int.tryParse(segment);
      return number != null && number >= 0 && number <= 255;
    });
  }

  set ip (String? value) {
    if(_isValidIp(value)) {
      _ip = value;
      _updatePref();
    } else {
      throw const FormatException("Invalid IP Format");
    }
  }

  bool _isValidPort(String? port) {
    if (port == null) return false;
    final number = int.tryParse(port);
    return number != null && number >= 0 && number <= 65535;
  }

  set port (String? value) {
    if(_isValidPort(value)) {
      _port = value;
      _updatePref();
    } else {
      throw const FormatException("Invalid Port Format");
    }
  }

  bool _isValidTimeout(String? timeout) {
    if (timeout == null) return false;
    final number = int.tryParse(timeout);
    return number != null && number > 0;
  }

  set timeout (String? value) {
    if(_isValidTimeout(value)) {
      _timeout = value;
      _updatePref();
    } else {
      throw const FormatException("Invalid Timeout Format");
    }
  }
}

class ServerCubit extends Cubit<ServerState> {
  ServerCubit() : super(ServerState._internal()){
    _initialize();
  }

  Future<void> _initialize() async {
    final initialState = await ServerState.create();
    emit(initialState);
  }
}