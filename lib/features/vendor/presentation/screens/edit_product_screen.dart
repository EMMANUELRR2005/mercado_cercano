import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/vendor_bloc.dart';
import '../providers/vendor_provider.dart';

const _units = ['lb', 'unidad', 'manojo', 'docena', 'porción'];

/// Edición de un producto existente del catálogo del vendedor.
class EditProductScreen extends ConsumerStatefulWidget {
  const EditProductScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _unit = 'lb';
  ProductCategory _category = ProductCategory.other;
  bool _isAvailable = true;

  /// Producto cargado desde el estado del bloc (catálogo en memoria).
  ProductEntity? _product;

  @override
  void initState() {
    super.initState();
    final bloc = ref.read(vendorProductsBlocProvider);
    final state = bloc.state;
    if (state is VendorProductsReady) {
      _loadFrom(state.products);
    } else {
      // Si se entró directo por deep link, pedimos el catálogo.
      bloc.add(const MyProductsRequested());
    }
  }

  void _loadFrom(List<ProductEntity> products) {
    final matches = products.where((p) => p.id == widget.productId);
    if (matches.isEmpty) return;
    final product = matches.first;
    _product = product;
    _nameController.text = product.name;
    _priceController.text = product.price.toStringAsFixed(2);
    _descriptionController.text = product.description ?? '';
    _unit = _units.contains(product.unit) ? product.unit! : 'lb';
    _category = product.category;
    _isAvailable = product.isAvailable;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final product = _product;
    if (product == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(vendorProductsBlocProvider).add(
          ProductUpdated(
            product.copyWith(
              name: _nameController.text.trim(),
              price:
                  double.parse(_priceController.text.replaceAll(',', '')),
              unit: _unit,
              category: _category,
              isAvailable: _isAvailable,
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(vendorProductsBlocProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Editar producto')),
      body: BlocConsumer<VendorProductsBloc, VendorProductsState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is VendorProductsReady && _product == null) {
            // El catálogo llegó después de entrar por deep link.
            setState(() => _loadFrom(state.products));
          }
          if (state is VendorProductActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.successGreen,
              ),
            );
            context.pop();
          }
          if (state is VendorProductActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VendorProductsLoading ||
              state is VendorProductsInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }
          if (state is VendorProductsError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => bloc.add(const MyProductsRequested()),
            );
          }
          if (_product == null) {
            return const EmptyStateWidget(
              icon: Icons.search_off,
              title: 'Producto no encontrado',
              subtitle: 'Puede que haya sido eliminado del catálogo.',
            );
          }
          final saving = state is VendorProductActionInProgress;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nombre', style: AppTextStyles.titleSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) =>
                        Validators.validateRequired(v, 'el nombre'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Precio',
                                style: AppTextStyles.titleSmall),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [PriceInputFormatter()],
                              decoration:
                                  const InputDecoration(prefixText: 'Q '),
                              validator: Validators.validatePrice,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Unidad',
                                style: AppTextStyles.titleSmall),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: _unit,
                              items: [
                                for (final unit in _units)
                                  DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit),
                                  ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _unit = v ?? 'lb'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Categoría', style: AppTextStyles.titleSmall),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: ProductCategory.values.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final category = ProductCategory.values[i];
                        return CategoryChip(
                          category: category,
                          isSelected: _category == category,
                          onTap: () =>
                              setState(() => _category = category),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Descripción (opcional)',
                      style: AppTextStyles.titleSmall),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.primaryGreen,
                    title: const Text('Disponible',
                        style: AppTextStyles.titleSmall),
                    subtitle: Text(
                      _isAvailable
                          ? 'Visible para compradores'
                          : 'Marcado como agotado',
                      style: AppTextStyles.bodySmall,
                    ),
                    value: _isAvailable,
                    onChanged: (v) => setState(() => _isAvailable = v),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saving ? null : _save,
                      child: saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Guardar cambios'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
