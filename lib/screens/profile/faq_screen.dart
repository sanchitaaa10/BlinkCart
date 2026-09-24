import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../data/mock_faqs.dart';
import '../../models/faq_item.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allFaqs = MockFaqs.faqs;
    final categories = ['All', ...allFaqs.map((f) => f.category).toSet()];

    final filteredFaqs = allFaqs.where((faq) {
      final matchesCat = _selectedCategory == 'All' || faq.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Help & FAQs', style: AppTypography.headingLarge),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Search Box
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search help topics, delivery, returns...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
            ),
          ),

          // Categories Filter Tabs
          Container(
            height: 48,
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.background,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),

          // FAQ Accordion List
          Expanded(
            child: filteredFaqs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.help_outline_rounded,
                            size: 48, color: AppColors.textTertiary),
                        const SizedBox(height: 12),
                        Text('No matching questions found',
                            style: AppTypography.headingSmall),
                        const SizedBox(height: 4),
                        Text('Try checking for typos or clear search',
                            style: AppTypography.bodySmall),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFaqs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final faq = filteredFaqs[index];
                      return _buildFaqTile(faq);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTile(FaqItem faq) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textTertiary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            faq.question,
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              faq.category,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                faq.answer,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
