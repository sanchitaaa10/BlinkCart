import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address.dart';

class AddressProvider extends ChangeNotifier {
  final List<Address> _addresses = [];
  String _selectedAddressId = 'addr-1';
  static const String _addressPrefKey = 'quickbasket_saved_addresses';
  static const String _selectedAddressPrefKey = 'quickbasket_selected_address_id';

  AddressProvider() {
    _loadAddressesFromPrefs();
  }

  List<Address> get addresses => [..._addresses];
  String get selectedAddressId => _selectedAddressId;

  Address get selectedAddress {
    try {
      return _addresses.firstWhere(
        (a) => a.id == _selectedAddressId,
        orElse: () => _addresses.first,
      );
    } catch (_) {
      return _defaultSampleAddress;
    }
  }

  static const Address _defaultSampleAddress = Address(
    id: 'addr-1',
    fullName: 'Sanchita',
    phoneNumber: '+91 98765 43210',
    houseFlatNumber: 'Flat 402, Lotus Heights',
    buildingName: 'Sector 20',
    streetArea: 'Kharghar',
    landmark: 'Near Central Park',
    city: 'Navi Mumbai',
    state: 'Maharashtra',
    pinCode: '410210',
    addressType: AddressType.home,
    isDefault: true,
  );

  void selectAddress(String id) {
    _selectedAddressId = id;
    _saveAddressesToPrefs();
    notifyListeners();
  }

  void addAddress(Address address) {
    if (address.isDefault) {
      _resetDefault();
    }
    _addresses.add(address);
    if (address.isDefault || _addresses.length == 1) {
      _selectedAddressId = address.id;
    }
    _saveAddressesToPrefs();
    notifyListeners();
  }

  void updateAddress(Address address) {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      if (address.isDefault) {
        _resetDefault();
      }
      _addresses[index] = address;
      _saveAddressesToPrefs();
      notifyListeners();
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    if (_selectedAddressId == id && _addresses.isNotEmpty) {
      _selectedAddressId = _addresses.first.id;
    }
    _saveAddressesToPrefs();
    notifyListeners();
  }

  void _resetDefault() {
    for (int i = 0; i < _addresses.length; i++) {
      if (_addresses[i].isDefault) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
  }

  Future<void> _saveAddressesToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _addresses.map((a) => a.toJson()).toList();
      await prefs.setString(_addressPrefKey, jsonEncode(list));
      await prefs.setString(_selectedAddressPrefKey, _selectedAddressId);
    } catch (e) {
      debugPrint('Error saving addresses: $e');
    }
  }

  Future<void> _loadAddressesFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_addressPrefKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
        _addresses.clear();
        for (final item in decoded) {
          _addresses.add(Address.fromJson(item as Map<String, dynamic>));
        }
      } else {
        // Initialize with default sample addresses
        _addresses.addAll([
          _defaultSampleAddress,
          const Address(
            id: 'addr-2',
            fullName: 'Sanchita',
            phoneNumber: '+91 98765 43210',
            houseFlatNumber: 'Office 804, Tech Park',
            buildingName: 'Tower B, Sector 30A',
            streetArea: 'Vashi',
            landmark: 'Opposite Inorbit Mall',
            city: 'Navi Mumbai',
            state: 'Maharashtra',
            pinCode: '400703',
            addressType: AddressType.work,
            isDefault: false,
          ),
        ]);
      }

      final savedSelected = prefs.getString(_selectedAddressPrefKey);
      if (savedSelected != null && _addresses.any((a) => a.id == savedSelected)) {
        _selectedAddressId = savedSelected;
      } else if (_addresses.isNotEmpty) {
        _selectedAddressId = _addresses.first.id;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    }
  }
}
