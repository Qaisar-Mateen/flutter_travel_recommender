import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.white
  )
);


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade800
  )
);

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  toggleTheme() {emit(darkTheme);}

  bool isDark() => state.brightness == Brightness.dark;
}