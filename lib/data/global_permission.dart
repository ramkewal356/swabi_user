import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings {
  static final GlobalSettings _instance = GlobalSettings._internal();

  factory GlobalSettings() {
    return _instance;
  }

  GlobalSettings._internal();

  late bool _financeManagement;
  late bool _batchManagement;
  late bool _traineeManagement;
  late bool _performanceManagement;
  late bool _isCoach;

  // Getter methods

  bool get financeManagement => _financeManagement;
  bool get batchManagement => _batchManagement;
  bool get traineeManagement => _traineeManagement;
  bool get performanceManagement => _performanceManagement;
  bool get isCoach => _isCoach;

  // Load data from SharedPreferences
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _financeManagement = prefs.getBool('financeManagement') ?? false;
    _batchManagement = prefs.getBool('batchManagement') ?? false;
    _traineeManagement = prefs.getBool('traineeManagement') ?? false;
    _performanceManagement = prefs.getBool('performanceManagement') ?? false;
    _isCoach = prefs.getBool('isCoach') ?? false;
  }

  // Save data to SharedPreferences
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('financeManagement', _financeManagement);
    prefs.setBool('batchManagement', _batchManagement);
    prefs.setBool('traineeManagement', _traineeManagement);
    prefs.setBool('performanceManagement', _performanceManagement);
    prefs.setBool('isCoach', _isCoach);
  }


  void updateProperties({
    bool financeManagement = false,
    bool batchManagement = false,
    bool traineeManagement = false,
    bool performanceManagement = false,
     bool isCoach = true,
  }) {
    _financeManagement = financeManagement;
    _batchManagement = batchManagement;
    _traineeManagement = traineeManagement;
    _performanceManagement = performanceManagement;
     _isCoach = isCoach;
  }
}
