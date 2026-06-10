import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../domain/entities/product_entity.dart';

/// Chip de categoría de producto, seleccionable para filtros.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  final ProductCategory category;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? Colors.white : AppColors.textPrimary;

    return Material(
      color: isSelected ? AppColors.primaryGreen : Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? AppColors.primaryGreen : AppColors.divider,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(
                category.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
