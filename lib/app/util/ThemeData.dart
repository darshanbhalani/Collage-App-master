import 'package:flutter/material.dart';

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
const COLOR_PRIMARY=Color.fromARGB(1,107, 103, 103);
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.green,
  primarySwatch: buildMaterialColor(Color(0xFF1E1E1E)),
  scaffoldBackgroundColor: buildMaterialColor(Color(0xFFE4E4E4)),
  drawerTheme: DrawerThemeData(
    backgroundColor:buildMaterialColor(Color(0xFFE4E4E4)),
  )

);

// ThemeData darkTheme = ThemeData(
//     // brightness: Brightness.dark,
//   primarySwatch: buildMaterialColor(Color(0xFF3399FF)),
//   primaryColor: Colors.green
// );


class ThemeManager with ChangeNotifier{
  ThemeMode _themeMode =ThemeMode.light;

  get themeMode => _themeMode;

  toggleTheme(bool isDark){
    _themeMode = isDark?ThemeMode.dark:ThemeMode.light;
    print(_themeMode);
    print("_________________________________________");
    notifyListeners();
  }
}