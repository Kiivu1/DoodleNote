import 'package:flutter/material.dart';
import 'package:doodle_note/services/preferences.dart';

class ConfigurationData extends ChangeNotifier{

  final SharedPreferencesService _sharedPrefs;

  bool _darkMode = false;
  int _sizeFont = 14;
  int _sizeFontTitle = 24; 
  int _typeFont = 0;
  int _menuLayout = 0;
  bool _showImage = true;
  bool _showDate = true;

  //GETTERS
  bool get darkMode => _darkMode;
  int get sizeFont => _sizeFont;
  int get sizeFontTitle => _sizeFontTitle;
  int get typeFont => _typeFont;
  int get menuLayout => _menuLayout;
  bool get showImage => _showImage;
  bool get showDate => _showDate;

  //Setters
  void setFontSize(int sizeFont){this._sizeFont = sizeFont; notifyListeners(); }
  void setFontType(int typeFont){ this._typeFont = typeFont; notifyListeners(); }
  void setFontTitleSize(int sizeFontTitle){ this._sizeFontTitle = sizeFontTitle; notifyListeners(); }
  void setMenuLayout(int menuLayout){ this._menuLayout = menuLayout; notifyListeners(); }
  void setDarkMode(bool darkMode){ this._darkMode = darkMode; notifyListeners(); }
  void setShowImage(bool showImage){ this._showImage = showImage; notifyListeners(); }
  void setShowDate(bool showDate){ this._showDate = showDate; notifyListeners(); }

  String? get FontFamily {
    switch (_typeFont) {
      case 0:
        return null;
      case 1:
        return 'Orbitron';
      case 2:
        return 'ComicRelief';
      default:
        return null;
    }
  }

  ConfigurationData(this._sharedPrefs){
    _loadPreferences();
  }



  Future<void> _loadPreferences() async {
    _darkMode = await _sharedPrefs.loadDarkMode();
    _sizeFont = await _sharedPrefs.loadFontSize();
    _sizeFontTitle = await _sharedPrefs.loadFontTitleSize();
    _typeFont = await _sharedPrefs.loadFontType();
    _menuLayout = await _sharedPrefs.loadMenuLayout();
    _showImage = await _sharedPrefs.loadShowIcon();
    _showDate = await _sharedPrefs.loadShowDate();
    notifyListeners();
  }
}