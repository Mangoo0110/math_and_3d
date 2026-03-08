
part of 'themes.dart';

class DAppBarTheme {
  DAppBarTheme._(); // Private constructor

  // Light AppBarTheme
  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.light().backgroundColor,
    //foregroundColor: AppColors.light().primaryColor,
    surfaceTintColor: AppColors.light().backgroundColor,//AppColors.light().backgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: AppColors.light().backgroundColor,
      statusBarIconBrightness: Brightness.dark
    ),
    //elevation: 0,
    //titleSpacing: 0,
    
    iconTheme: IconThemeData(
      color: AppColors.light().textColor,
      size: 18  
    ),
    actionsIconTheme: IconThemeData(color: AppColors.light().textColor, size: 18),
    toolbarTextStyle: TextStyle(color: AppColors.light().textColor),
    titleTextStyle: TextStyle(
      color: AppColors.light().textColor,
      fontWeight: FontWeight.w600,
      fontSize: 18
    ),
    centerTitle: true,
  );

  // Dark AppBarTheme
  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.dark().backgroundColor,
    //foregroundColor: AppColors.dark().primaryColor,
    surfaceTintColor: AppColors.dark().backgroundColor,//AppColors.dark().backgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: AppColors.dark().backgroundColor,
      statusBarIconBrightness: Brightness.light
    ),
    //elevation: 0,
    //titleSpacing: 0,
    
    iconTheme: IconThemeData(
      color: AppColors.dark().textColor,
      size: 18  
    ),
    actionsIconTheme: IconThemeData(color: AppColors.dark().textColor, size: 18),
    toolbarTextStyle: TextStyle(color: AppColors.dark().textColor),
    titleTextStyle: TextStyle(
      color: AppColors.dark().textColor,
      fontWeight: FontWeight.w600,
      fontSize: 18
    ),
    centerTitle: true,
  );

  static AppBarTheme getAppBarTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightAppBarTheme : darkAppBarTheme;
  }
}