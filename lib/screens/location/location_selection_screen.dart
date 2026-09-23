import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/location_provider.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTag = 'Home';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final currentLocation = locationProvider.currentLocation;

    final filteredPresets = LocationProvider.presetLocations.where((loc) {
      if (_searchQuery.isEmpty) return true;
      return loc.area.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          loc.city.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Select Delivery Location',
          style: AppTypography.headingMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              'Where should we deliver?',
              style: AppTypography.displayMedium.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              'Select your location to see products available near you in 10-20 mins',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Search Bar
            CustomTextField(
              controller: _searchController,
              hintText: 'Search for area, street or landmark...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
            const SizedBox(height: 16),

            // Use Current Location Button Card
            InkWell(
              onTap: () {
                locationProvider.setCustomLocation(
                  'Kharghar Sector 20',
                  'Navi Mumbai',
                  _selectedTag,
                  '410210',
                );
                Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
              },
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Use Current Location',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Allow BlinkCart to access your GPS location',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primaryDark.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Currently Selected Location Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Delivering to',
                        style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentLocation.tag,
                    style: AppTypography.headingSmall.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '${currentLocation.area}, ${currentLocation.city} - ${currentLocation.pincode}',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  // Tag selection pills
                  Row(
                    children: ['Home', 'Work', 'Other'].map((tag) {
                      final isSelected = _selectedTag == tag;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedTag = tag;
                              });
                            }
                          },
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Saved / Popular Areas
            Text(
              'Popular Delivery Areas',
              style: AppTypography.headingSmall,
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredPresets.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final loc = filteredPresets[index];
                final isCurrent = loc.area == currentLocation.area;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.primarySubtle : AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.place_outlined,
                      color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    loc.area,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    '${loc.city} • PIN ${loc.pincode}',
                    style: AppTypography.bodySmall,
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                      : const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                  onTap: () {
                    locationProvider.setLocation(loc);
                    Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Confirm Button
            CustomButton(
              text: 'Confirm & Continue',
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
              },
              backgroundColor: AppColors.primary,
              height: AppDimensions.buttonHeightLg,
            ),
          ],
        ),
      ),
    );
  }
}
