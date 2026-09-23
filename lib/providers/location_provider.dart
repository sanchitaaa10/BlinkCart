import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryLocation {
  final String area;
  final String city;
  final String tag;
  final String pincode;

  const DeliveryLocation({
    required this.area,
    required this.city,
    required this.tag,
    required this.pincode,
  });

  String get fullDisplay => '$area, $city';
}

class LocationProvider extends ChangeNotifier {
  DeliveryLocation _currentLocation = const DeliveryLocation(
    area: 'Kharghar',
    city: 'Navi Mumbai',
    tag: 'Home',
    pincode: '410210',
  );

  static const List<DeliveryLocation> presetLocations = [
    DeliveryLocation(area: 'Kharghar', city: 'Navi Mumbai', tag: 'Home', pincode: '410210'),
    DeliveryLocation(area: 'Vashi', city: 'Navi Mumbai', tag: 'Work', pincode: '400703'),
    DeliveryLocation(area: 'Panvel', city: 'Navi Mumbai', tag: 'Other', pincode: '410206'),
    DeliveryLocation(area: 'Seawoods', city: 'Navi Mumbai', tag: 'Other', pincode: '400706'),
    DeliveryLocation(area: 'Thane West', city: 'Thane', tag: 'Other', pincode: '400601'),
    DeliveryLocation(area: 'Bandra West', city: 'Mumbai', tag: 'Other', pincode: '400050'),
    DeliveryLocation(area: 'Andheri East', city: 'Mumbai', tag: 'Work', pincode: '400069'),
    DeliveryLocation(area: 'Powai', city: 'Mumbai', tag: 'Home', pincode: '400076'),
  ];

  static const String _prefAreaKey = 'qb_loc_area';
  static const String _prefCityKey = 'qb_loc_city';
  static const String _prefTagKey = 'qb_loc_tag';
  static const String _prefPincodeKey = 'qb_loc_pincode';

  LocationProvider() {
    _loadFromPrefs();
  }

  DeliveryLocation get currentLocation => _currentLocation;

  void setLocation(DeliveryLocation location) {
    _currentLocation = location;
    _saveToPrefs();
    notifyListeners();
  }

  void setCustomLocation(String area, String city, String tag, String pincode) {
    _currentLocation = DeliveryLocation(
      area: area,
      city: city,
      tag: tag,
      pincode: pincode,
    );
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefAreaKey, _currentLocation.area);
      await prefs.setString(_prefCityKey, _currentLocation.city);
      await prefs.setString(_prefTagKey, _currentLocation.tag);
      await prefs.setString(_prefPincodeKey, _currentLocation.pincode);
    } catch (e) {
      debugPrint('Error saving location: $e');
    }
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final area = prefs.getString(_prefAreaKey);
      final city = prefs.getString(_prefCityKey);
      final tag = prefs.getString(_prefTagKey);
      final pin = prefs.getString(_prefPincodeKey);

      if (area != null && city != null) {
        _currentLocation = DeliveryLocation(
          area: area,
          city: city,
          tag: tag ?? 'Home',
          pincode: pin ?? '410210',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading location: $e');
    }
  }
}
