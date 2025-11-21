import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService{

  static const String _darkModeKey = 'dark_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _fontTitleSizeKey = 'font_title_size';
  static const String _fontTypeKey = 'font_type';
  static const String _menuTypeKey = 'menu_type';
  static const String _showIconKey = 'show_icon';
  static const String _showDateKey = 'show_date';

  //-----------------------------------------------------------------------

  Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  Future<void> saveFontsSize(int fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontSizeKey, fontSize);
  }

  Future<void> saveFontTitleSize(int fontTitleSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontTitleSizeKey, fontTitleSize);
  }

  Future<void> saveFontType(int fontType) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontTypeKey, fontType);
  }

  Future<void> saveMenuLayout(int menuType) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_menuTypeKey, menuType);
  }

  Future<void> saveShowIcon(bool showImage) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showIconKey, showImage);
  }

  Future<void> saveShowDate(bool showDate) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showDateKey, showDate);
  }

  //-----------------------------------------------------------------------

  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<int> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_fontSizeKey) ?? 12;
  }

  Future<int> loadFontTitleSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_fontTitleSizeKey) ?? 16;
  }

  Future<int> loadFontType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_fontTypeKey) ?? 0;
  }

  Future<int> loadMenuLayout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_menuTypeKey) ?? 0;
  }

  Future<bool> loadShowIcon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showIconKey) ?? true;
  }

  Future<bool> loadShowDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showDateKey) ?? true;
  }

  Future<void> saveAutoSync(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_sync', value);
  }

  Future<bool> loadAutoSync() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('auto_sync') ?? false; 
  }

}