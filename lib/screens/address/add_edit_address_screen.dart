import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/address.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/address_provider.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? initialAddress;

  const AddEditAddressScreen({
    super.key,
    this.initialAddress,
  });

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _flatController;
  late final TextEditingController _buildingController;
  late final TextEditingController _streetController;
  late final TextEditingController _landmarkController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pinController;

  AddressType _selectedType = AddressType.home;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final a = widget.initialAddress;
    _nameController = TextEditingController(text: a?.fullName ?? 'Sanchita');
    _phoneController = TextEditingController(text: a?.phoneNumber ?? '9876543210');
    _flatController = TextEditingController(text: a?.houseFlatNumber ?? '');
    _buildingController = TextEditingController(text: a?.buildingName ?? '');
    _streetController = TextEditingController(text: a?.streetArea ?? 'Sector 20, Kharghar');
    _landmarkController = TextEditingController(text: a?.landmark ?? 'Near Central Park');
    _cityController = TextEditingController(text: a?.city ?? 'Navi Mumbai');
    _stateController = TextEditingController(text: a?.state ?? 'Maharashtra');
    _pinController = TextEditingController(text: a?.pinCode ?? '410210');
    _selectedType = a?.addressType ?? AddressType.home;
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _flatController.dispose();
    _buildingController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final addressProvider = context.read<AddressProvider>();
    final isEditing = widget.initialAddress != null;
    final newId = isEditing
        ? widget.initialAddress!.id
        : 'addr-${DateTime.now().millisecondsSinceEpoch}';

    final address = Address(
      id: newId,
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      houseFlatNumber: _flatController.text.trim(),
      buildingName: _buildingController.text.trim(),
      streetArea: _streetController.text.trim(),
      landmark: _landmarkController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pinCode: _pinController.text.trim(),
      addressType: _selectedType,
      isDefault: _isDefault,
    );

    if (isEditing) {
      addressProvider.updateAddress(address);
      ToastUtils.showSuccess(context, 'Address updated successfully');
    } else {
      addressProvider.addAddress(address);
      ToastUtils.showSuccess(context, 'New address added');
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialAddress != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Address' : 'Add New Address', style: AppTypography.headingLarge),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              onPressed: () {
                context.read<AddressProvider>().deleteAddress(widget.initialAddress!.id);
                ToastUtils.showInfo(context, 'Address deleted');
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Details Section
              Text('Contact Details', style: AppTypography.headingSmall),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'Enter your name',
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: 'Enter 10-digit mobile number',
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Enter phone number';
                  }
                  if (val.trim().length < 10) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Address Details Section
              Text('Address Details', style: AppTypography.headingSmall),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _flatController,
                      labelText: 'Flat / House No.',
                      hintText: 'e.g. Flat 402',
                      validator: (val) => val == null || val.trim().isEmpty ? 'Enter flat/house no.' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _buildingController,
                      labelText: 'Building Name',
                      hintText: 'e.g. Lotus Heights',
                      validator: (val) => val == null || val.trim().isEmpty ? 'Enter building name' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _streetController,
                labelText: 'Street / Area',
                hintText: 'e.g. Sector 20, Kharghar',
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter street or area' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _landmarkController,
                labelText: 'Landmark (Optional)',
                hintText: 'e.g. Near Central Park',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _cityController,
                      labelText: 'City',
                      hintText: 'Navi Mumbai',
                      validator: (val) => val == null || val.trim().isEmpty ? 'Enter city' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _pinController,
                      labelText: 'PIN Code',
                      hintText: '410210',
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Enter PIN code';
                        if (val.trim().length != 6) return 'PIN must be 6 digits';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Save as Tag
              Text('Save Address As', style: AppTypography.headingSmall),
              const SizedBox(height: 10),
              Row(
                children: AddressType.values.map((type) {
                  final isSelected = _selectedType == type;
                  final label = type == AddressType.home
                      ? 'Home'
                      : (type == AddressType.work ? 'Work' : 'Other');
                  final icon = type == AddressType.home
                      ? Icons.home_rounded
                      : (type == AddressType.work ? Icons.work_rounded : Icons.location_on_rounded);

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      avatar: Icon(
                        icon,
                        size: 16,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
                      label: Text(label),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Default Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Set as default delivery address', style: AppTypography.bodyMedium),
                value: _isDefault,
                activeTrackColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _isDefault = val;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Save Button
              CustomButton(
                text: isEditing ? 'Save Changes' : 'Save Address',
                onPressed: _saveAddress,
                backgroundColor: AppColors.primary,
                height: AppDimensions.buttonHeightLg,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
