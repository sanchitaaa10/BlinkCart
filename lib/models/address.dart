enum AddressType {
  home,
  work,
  other,
}

class Address {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String houseFlatNumber;
  final String buildingName;
  final String streetArea;
  final String landmark;
  final String city;
  final String state;
  final String pinCode;
  final AddressType addressType;
  final bool isDefault;

  const Address({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.houseFlatNumber,
    required this.buildingName,
    required this.streetArea,
    this.landmark = '',
    required this.city,
    required this.state,
    required this.pinCode,
    this.addressType = AddressType.home,
    this.isDefault = false,
  });

  String get formattedAddress {
    final parts = [
      '$houseFlatNumber, $buildingName',
      streetArea,
      if (landmark.isNotEmpty) 'Near $landmark',
      '$city, $state - $pinCode',
    ];
    return parts.join(', ');
  }

  String get shortLocation => '$streetArea, $city';

  String get tagLabel {
    switch (addressType) {
      case AddressType.home:
        return 'Home';
      case AddressType.work:
        return 'Work';
      case AddressType.other:
        return 'Other';
    }
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      houseFlatNumber: json['houseFlatNumber'] as String,
      buildingName: json['buildingName'] as String,
      streetArea: json['streetArea'] as String,
      landmark: json['landmark'] as String? ?? '',
      city: json['city'] as String,
      state: json['state'] as String,
      pinCode: json['pinCode'] as String,
      addressType: AddressType.values.firstWhere(
        (e) => e.name == json['addressType'],
        orElse: () => AddressType.home,
      ),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'houseFlatNumber': houseFlatNumber,
      'buildingName': buildingName,
      'streetArea': streetArea,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'addressType': addressType.name,
      'isDefault': isDefault,
    };
  }

  Address copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? houseFlatNumber,
    String? buildingName,
    String? streetArea,
    String? landmark,
    String? city,
    String? state,
    String? pinCode,
    AddressType? addressType,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      houseFlatNumber: houseFlatNumber ?? this.houseFlatNumber,
      buildingName: buildingName ?? this.buildingName,
      streetArea: streetArea ?? this.streetArea,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      addressType: addressType ?? this.addressType,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
