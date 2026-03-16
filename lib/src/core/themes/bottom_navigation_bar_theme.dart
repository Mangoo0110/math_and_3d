part of 'themes.dart';

class DBottomNavigationBarThemes {
  DBottomNavigationBarThemes._(); // Private constructor

  // Light BottomNavigationBarTheme
  static BottomNavigationBarThemeData lightBottomNavTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColors.light().bottomNavigationBarColor,
    selectedItemColor: AppColors.light().primaryColor,
    unselectedItemColor: Colors.black87,
    selectedIconTheme: IconThemeData(
      color: AppColors.light().primaryColor,
      size: 28,
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.black87,
      size: 28,
    ),
    selectedLabelStyle: TextStyle(
      fontFamily: "Outfit",
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.light().primaryColor,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: "Outfit",
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    elevation: 0.0,
    type: BottomNavigationBarType.fixed,
  );

  // Dark BottomNavigationBarTheme
  static BottomNavigationBarThemeData darkBottomNavTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColors.dark().bottomNavigationBarColor, // Background color for the bottom navigation bar
    selectedItemColor: AppColors.dark().primaryColor, // Color of the selected item
    unselectedItemColor: AppColors.dark().invertTextColor, // Color of unselected items
    selectedIconTheme: IconThemeData(
      color: AppColors.dark().primaryColor, // Icon color for the selected item
      size: 28, // Icon size for the selected item
    ),
    unselectedIconTheme: IconThemeData(
      color: AppColors.dark().invertTextColor, // Icon color for unselected items
      size: 28, // Icon size for unselected items
    ),
    selectedLabelStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: AppColors.dark().primaryColor, // Text style for the selected label
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: AppColors.dark().invertTextColor, // Text style for unselected labels
    ),
    showSelectedLabels: true, // Whether or not to show labels for selected items
    showUnselectedLabels: true, // Whether or not to show labels for unselected items
    elevation: 8.0, // Elevation of the bottom navigation bar
  );
}
