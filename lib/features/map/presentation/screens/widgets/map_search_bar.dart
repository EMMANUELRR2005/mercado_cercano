import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/domain/entities/product_entity.dart';
import '../../../../../shared/widgets/category_chip.dart';

/// Barra de búsqueda flotante del mapa: filtro de texto + chips de
/// categoría en scroll horizontal.
class MapSearchBar extends StatelessWidget {
  const MapSearchBar({
    super.key,
    required this.query,
    required this.selectedCategory,
    required this.onQueryChanged,
    required this.onCategoryChanged,
  });

  final String query;
  final ProductCategory? selectedCategory;
  final ValueChanged<String> onQueryChanged;

  /// Recibe null cuando se selecciona "Todas".
  final ValueChanged<ProductCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(28),
          color: AppColors.surfaceWhite,
          child: TextField(
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Buscar vendedor o producto…',
              hintStyle: const TextStyle(color: AppColors.textHint),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Chip "Todas" para limpiar el filtro de categoría.
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: selectedCategory == null
                      ? AppColors.primaryGreen
                      : AppColors.surfaceWhite,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: selectedCategory == null
                          ? AppColors.primaryGreen
                          : AppColors.divider,
                    ),
                  ),
                  elevation: 2,
                  child: InkWell(
                    onTap: () => onCategoryChanged(null),
                    customBorder: const StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: Text(
                        'Todas',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selectedCategory == null
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              for (final category in ProductCategory.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    // Fondo blanco bajo el chip (su Material es transparente)
                    // para que se lea bien sobre el mapa.
                    color: AppColors.surfaceWhite,
                    elevation: 2,
                    shape: const StadiumBorder(),
                    child: CategoryChip(
                      category: category,
                      isSelected: category == selectedCategory,
                      onTap: () => onCategoryChanged(
                        category == selectedCategory ? null : category,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
