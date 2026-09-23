import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_typography.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final double height;
  final double width;
  final bool isCompact;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onIncrease,
    required this.onDecrease,
    this.height = 32,
    this.width = 75,
    this.isCompact = true,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return SizedBox(
        height: height,
        width: width,
        child: OutlinedButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            onAdd();
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            'ADD',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: isCompact ? 12 : 14,
            ),
          ),
        ),
      );
    }

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onDecrease();
            },
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(6)),
            child: Container(
              height: height,
              width: width * 0.32,
              alignment: Alignment.center,
              child: Icon(
                quantity == 1 ? Icons.delete_outline_rounded : Icons.remove_rounded,
                size: isCompact ? 14 : 16,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            quantity.toString(),
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: isCompact ? 12 : 14,
            ),
          ),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onIncrease();
            },
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
            child: Container(
              height: height,
              width: width * 0.32,
              alignment: Alignment.center,
              child: Icon(
                Icons.add_rounded,
                size: isCompact ? 14 : 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
