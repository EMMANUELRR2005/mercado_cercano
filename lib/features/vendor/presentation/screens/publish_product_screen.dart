import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/product_draft.dart';
import '../bloc/vendor_bloc.dart';
import '../providers/vendor_provider.dart';

/// Flujo de publicación en MÁXIMO 3 toques (PageView de 3 pasos):
/// 1. Foto (cámara/galería o continuar sin foto).
/// 2. Datos: nombre, precio, unidad y categoría.
/// 3. Confirmación → Publicar → animación de éxito → home.
class PublishProductScreen extends ConsumerStatefulWidget {
  const PublishProductScreen({super.key});

  @override
  ConsumerState<PublishProductScreen> createState() =>
      _PublishProductScreenState();
}

class _PublishProductScreenState extends ConsumerState<PublishProductScreen>
    with SingleTickerProviderStateMixin {
  static const _units = ['lb', 'unidad', 'manojo', 'docena', 'porción'];

  /// Sugerencias de productos comunes en mercados de Guatemala.
  static const _nameSuggestions = [
    'Tomate',
    'Cebolla',
    'Papa',
    'Aguacate',
    'Banano',
    'Plátano',
    'Güisquil',
    'Cilantro',
    'Limón',
    'Chile pimiento',
    'Zanahoria',
    'Frijol negro',
    'Maíz',
    'Arroz',
    'Pollo',
    'Carne de res',
    'Carne de cerdo',
    'Queso fresco',
    'Crema',
    'Huevos',
    'Tostadas',
    'Tamales',
    'Chuchitos',
    'Atol de elote',
    'Rellenitos',
  ];

  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _picker = ImagePicker();

  int _currentStep = 0;

  // --- Borrador ---
  File? _photoFile;
  String _name = '';
  String _unit = 'lb';
  ProductCategory _category = ProductCategory.fruitsVegetables;

  // --- Éxito ---
  bool _showSuccess = false;
  late final AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _priceController.dispose();
    _successController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Navegación entre pasos
  // -------------------------------------------------------------------------

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // -------------------------------------------------------------------------
  // Paso 1: foto
  // -------------------------------------------------------------------------

  Future<void> _pickImage(ImageSource source) async {
    // En simulador la cámara puede no existir: capturamos cualquier fallo
    // y dejamos seguir el flujo (se puede publicar sin foto).
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => _photoFile = File(picked.path));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'No se pudo abrir la cámara. Puedes continuar sin foto.'
                : 'No se pudo abrir la galería. Puedes continuar sin foto.',
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  // -------------------------------------------------------------------------
  // Paso 3: publicar
  // -------------------------------------------------------------------------

  double get _price =>
      double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0;

  /// URL de la foto que "sube" el mock. Si hay foto local primero se
  /// comprime (como haría la subida real); el backend simulado devuelve
  /// una URL de picsum.
  Future<String> _uploadPhoto() async {
    final seed = DateTime.now().millisecondsSinceEpoch % 1000;
    final placeholder = 'https://picsum.photos/seed/nuevo$seed/400/300';

    final file = _photoFile;
    if (file == null) return placeholder;

    try {
      // Comprimir ANTES de subir: ahorra datos móviles al vendedor.
      await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 800,
        minHeight: 600,
        quality: 70,
      );
    } catch (_) {
      // Si la compresión falla (p. ej. en simulador), se "sube" igual.
    }
    return placeholder;
  }

  Future<void> _publish() async {
    final photoUrl = await _uploadPhoto();
    if (!mounted) return;
    ref.read(vendorProductsBlocProvider).add(
          ProductCreated(
            ProductDraft(
              name: _name.trim(),
              price: _price,
              category: _category,
              photoUrl: photoUrl,
              unit: _unit,
            ),
          ),
        );
  }

  Future<void> _onPublished() async {
    setState(() => _showSuccess = true);
    HapticFeedback.mediumImpact();
    await _successController.forward();
    // Pequeña pausa para que se aprecie el check verde.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) context.go(RouteNames.vendorHomePath);
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(vendorProductsBlocProvider);

    return BlocListener<VendorProductsBloc, VendorProductsState>(
      bloc: bloc,
      listener: (context, state) {
        // Solo nos interesa el resultado de NUESTRA publicación.
        final route = ModalRoute.of(context);
        if (route != null && !route.isCurrent) return;

        if (state is VendorProductActionSuccess &&
            state.createdProduct != null) {
          _onPublished();
        } else if (state is VendorProductActionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
            ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Publicar producto'),
          leading: _currentStep > 0 && !_showSuccess
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _goToStep(_currentStep - 1),
                )
              : null,
        ),
        body: SafeArea(
          child: _showSuccess
              ? _SuccessView(controller: _successController)
              : Column(
                  children: [
                    const OfflineBanner(),
                    const SizedBox(height: 12),
                    _StepIndicator(currentStep: _currentStep),
                    const SizedBox(height: 4),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        // Se avanza solo con los botones (flujo guiado).
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildPhotoStep(),
                          _buildDataStep(),
                          _buildConfirmStep(bloc),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // --- Paso 1 ---

  Widget _buildPhotoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('1. Tomale una foto a tu producto',
              style: AppTextStyles.headlineSmall),
          const SizedBox(height: 6),
          Text(
            'Una buena foto vende más. También puedes continuar sin foto.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 20),
          // Preview de la foto elegida.
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: _photoFile != null
                  ? Image.file(_photoFile!, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.divider.withValues(alpha: 0.5),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 56,
                        color: AppColors.textHint,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Cámara'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: const BorderSide(color: AppColors.primaryGreen),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galería'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () => _goToStep(1),
            child: Text(
              _photoFile != null ? 'Continuar' : 'Continuar sin foto',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // --- Paso 2 ---

  Widget _buildDataStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('2. ¿Qué vendés y a cuánto?',
                style: AppTextStyles.headlineSmall),
            const SizedBox(height: 20),

            // Nombre con autocompletado de productos comunes.
            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                final query = textEditingValue.text.trim().toLowerCase();
                if (query.isEmpty) return const Iterable<String>.empty();
                return _nameSuggestions.where(
                  (s) => s.toLowerCase().contains(query),
                );
              },
              onSelected: (value) => setState(() => _name = value),
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto',
                    hintText: 'Ej. Tomate, Aguacate, Tostadas…',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      Validators.validateRequired(value, 'el nombre'),
                  onChanged: (value) => _name = value,
                  onFieldSubmitted: (_) => onFieldSubmitted(),
                );
              },
            ),
            const SizedBox(height: 16),

            // Precio + unidad.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [PriceInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      prefixText: 'Q ',
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.validatePrice,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _unit,
                    decoration: const InputDecoration(
                      labelText: 'Unidad',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final unit in _units)
                        DropdownMenuItem(value: unit, child: Text(unit)),
                    ],
                    onChanged: (value) =>
                        setState(() => _unit = value ?? 'lb'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text('Categoría', style: AppTextStyles.titleSmall),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final category in ProductCategory.values) ...[
                    CategoryChip(
                      category: category,
                      isSelected: category == _category,
                      onTap: () => setState(() => _category = category),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  FocusScope.of(context).unfocus();
                  _goToStep(2);
                }
              },
              child: const Text('Continuar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // --- Paso 3 ---

  Widget _buildConfirmStep(VendorProductsBloc bloc) {
    final now = DateTime.now();
    // Entidad temporal solo para el preview estilo ProductCard.
    final preview = ProductEntity(
      id: 'preview',
      vendorId: 'preview',
      name: _name.trim().isEmpty ? 'Mi producto' : _name.trim(),
      category: _category,
      price: _price,
      photoUrl: '',
      isAvailable: true,
      expiresAt: now.add(const Duration(hours: 24)),
      createdAt: now,
      viewCount: 0,
      clickCount: 0,
      unit: _unit,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('3. Revisa y publica', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 6),
          Text(
            'Tu publicación estará visible 24 horas.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          // Preview: foto local + datos en tarjeta.
          if (_photoFile != null)
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.file(_photoFile!, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(preview.name, style: AppTextStyles.titleMedium),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PriceTag(price: preview.price),
                            Text(' / $_unit',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            ProductCard(product: preview),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(_category.icon, size: 18, color: _category.pinColor),
              const SizedBox(width: 6),
              Text(_category.label, style: AppTextStyles.bodyMedium),
              const Spacer(),
              Text(
                '${Formatters.formatQuetzal(_price)} / $_unit',
                style: AppTextStyles.priceSmall,
              ),
            ],
          ),
          const SizedBox(height: 28),
          BlocBuilder<VendorProductsBloc, VendorProductsState>(
            bloc: bloc,
            builder: (context, state) {
              final isPublishing = state is VendorProductActionInProgress;
              return FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isPublishing ? null : _publish,
                icon: isPublishing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.storefront),
                label: Text(
                  isPublishing ? 'Publicando…' : 'Publicar',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Indicador de progreso de los 3 pasos.
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          for (var i = 0; i < 3; i++) ...[
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 6,
                decoration: BoxDecoration(
                  color: i <= currentStep
                      ? AppColors.primaryGreen
                      : AppColors.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            if (i < 2) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

/// Check verde con ScaleTransition al publicar con éxito.
class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: CurvedAnimation(
              parent: controller,
              curve: Curves.elasticOut,
            ),
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: AppColors.successGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 64),
            ),
          ),
          const SizedBox(height: 20),
          Text('¡Producto publicado!', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 6),
          Text(
            'Ya es visible para los compradores cercanos.',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
