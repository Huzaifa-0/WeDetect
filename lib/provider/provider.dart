import 'package:flutter/foundation.dart';

class DataProvider with ChangeNotifier {
  String _gender = 'Male';

  String get gender => _gender;

  set gender(String gender) {
    _gender = gender;
    notifyListeners();
  }
}
