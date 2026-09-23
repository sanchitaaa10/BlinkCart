import 'package:flutter/material.dart';

class BrandSpotlight {
  final String id;
  final String name;
  final String tagline;
  final String discountOffer;
  final String logoUrl;
  final Color brandColor;
  final String targetCategory;
  final int productCount;

  const BrandSpotlight({
    required this.id,
    required this.name,
    required this.tagline,
    required this.discountOffer,
    required this.logoUrl,
    required this.brandColor,
    required this.targetCategory,
    required this.productCount,
  });
}
