import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/search_filters.dart';
import '../bloc/buyer_bloc.dart';
import '../providers/buyer_provider.dart';

/// Búsqueda por texto y/o categoría con filtros avanzados.
///
/// Recibe `query` y `category` opcionales (vienen como query params de
/// `/buyer/search`).
class CategorySearchScreen extends ConsumerStatefulWidget {
  const CategorySearchScreen({super.key, this.query, this.category});

  final String? query;
  final ProductCategory? category;

  @override
  ConsumerState<CategorySearchScreen> createState() =>
      _CategorySearchScreenState();
}

class _CategorySearchScreenState extends ConsumerState<CategorySearchScreen> {
  late final BuyerBloc _bloc;
  late final TextEditingController _searchController;
  SearchFilters _filters = const SearchFilters();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _filters = SearchFilters(category: widget.category);
    _bloc = createBuyerBloc(ref);
    _search();
  }

  @override
  void dispose() {
    _bloc.close();
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    _bloc.add(
      BuyerSearchRequested(
        query: query.isEmpty ? null : query,
        filters: _filters,
      ),
    );
  }

  Future<void> _openFilters() async {
    final updated = await showModalBottomSheet<SearchFilters>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FiltersSheet(initial: _filters),
    );
    if (updated != null) {
      setState(() => _filters = updated);
      _search();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: widget.query == null && widget.category == null,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Buscar productos…',
            hintStyle:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
            prefixIcon:
                const Icon(Icons.search, color: AppColors.textSecondary),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Filtros',
            onPressed: _openFilters,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          // Chips de categoría para refinar rápido sin abrir filtros.
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: ProductCategory.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final category = ProductCategory.values[i];
                final isSelected = _filters.category == category;
                return CategoryChip(
                  category: category,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _filters = _filters.copyWith(
                        category: isSelected ? null : category,
                      );
                    });
                    _search();
                  },
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<BuyerBloc, BuyerState>(
              bloc: _bloc,
              builder: (context, state) {
                return switch (state) {
                  BuyerLoading() || BuyerInitial() => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  BuyerError(:final message) => ErrorStateWidget(
                      message: message,
                      onRetry: _search,
                    ),
                  BuyerSearchLoaded(:final results) => results.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.search_off,
                          title: 'No encontramos productos cerca',
                          subtitle:
                              'Prueba ampliar el radio o quitar filtros.',
                          actionLabel: 'Ajustar filtros',
                          onAction: _openFilters,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: results.length,
                          itemBuilder: (context, i) {
                            final result = results[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ProductCard(
                                product: result.product,
                                distanceKm: result.distanceKm,
                                onTap: () => context.pushNamed(
                                  RouteNames.buyerProductDetail,
                                  pathParameters: {'id': result.product.id},
                                ),
                              ),
                            );
                          },
                        ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet de filtros avanzados; devuelve los filtros elegidos
/// con `Navigator.pop(context, filters)`.
class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({required this.initial});

  final SearchFilters initial;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late SearchFilters _filters = widget.initial;
  late final _maxPriceController = TextEditingController(
    text: widget.initial.maxPrice?.toStringAsFixed(0) ?? '',
  );

  @override
  void dispose() {
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Filtros', style: AppTextStyles.titleLarge),
            const SizedBox(height: 16),
            Text(
              'Radio de búsqueda: ${_filters.radiusKm.toStringAsFixed(0)} km',
              style: AppTextStyles.titleSmall,
            ),
            Slider(
              value: _filters.radiusKm.clamp(1, 20),
              min: 1,
              max: 20,
              divisions: 19,
              activeColor: AppColors.primaryGreen,
              label: '${_filters.radiusKm.toStringAsFixed(0)} km',
              onChanged: (v) =>
                  setState(() => _filters = _filters.copyWith(radiusKm: v)),
            ),
            const SizedBox(height: 8),
            const Text('Precio máximo', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _maxPriceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [PriceInputFormatter()],
              decoration: const InputDecoration(
                prefixText: 'Q ',
                hintText: 'Sin límite',
              ),
              onChanged: (v) {
                final parsed = double.tryParse(v.replaceAll(',', ''));
                setState(
                  () => _filters = _filters.copyWith(maxPrice: parsed),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text('Calificación mínima', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            StarRating(
              rating: _filters.minRating,
              interactive: true,
              size: 32,
              onChanged: (v) =>
                  setState(() => _filters = _filters.copyWith(minRating: v)),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.primaryGreen,
              title: const Text(
                'Solo disponibles',
                style: AppTextStyles.titleSmall,
              ),
              value: _filters.onlyAvailable,
              onChanged: (v) => setState(
                () => _filters = _filters.copyWith(onlyAvailable: v),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Ordenar por', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SortOrder.values.map((order) {
                final selected = _filters.sortBy == order;
                return ChoiceChip(
                  label: Text(order.label),
                  selected: selected,
                  selectedColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                  onSelected: (_) => setState(
                    () => _filters = _filters.copyWith(sortBy: order),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _filters),
                child: const Text('Aplicar filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
