import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/buyer_bloc.dart';
import '../providers/buyer_provider.dart';

/// Productos comunes para el autocomplete del reporte ciudadano.
const _commonProducts = [
  'Tomate',
  'Cebolla',
  'Papa',
  'Aguacate',
  'Frijol negro',
  'Maíz',
  'Pollo',
  'Queso fresco',
  'Huevos',
  'Plátano',
  'Arroz',
  'Azúcar',
  'Café',
  'Chile pimiento',
  'Limón',
];

const _units = ['lb', 'unidad', 'manojo', 'docena', 'porción', 'cartón'];

/// Reporte ciudadano de precio: alimenta el índice colaborativo.
class ReportPriceScreen extends ConsumerStatefulWidget {
  const ReportPriceScreen({super.key, this.initialProduct});

  final String? initialProduct;

  @override
  ConsumerState<ReportPriceScreen> createState() => _ReportPriceScreenState();
}

class _ReportPriceScreenState extends ConsumerState<ReportPriceScreen> {
  late final BuyerBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  late final _productController =
      TextEditingController(text: widget.initialProduct);
  final _priceController = TextEditingController();
  final _zoneController = TextEditingController();
  String _unit = 'lb';

  @override
  void initState() {
    super.initState();
    _bloc = createBuyerBloc(ref);
  }

  @override
  void dispose() {
    _bloc.close();
    _productController.dispose();
    _priceController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _bloc.add(
      BuyerPriceReported(
        productName: _productController.text.trim(),
        price: double.parse(_priceController.text.replaceAll(',', '')),
        unit: _unit,
        zone: _zoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar precio')),
      body: BlocConsumer<BuyerBloc, BuyerState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is BuyerReportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Gracias por reportar! Tu aporte mejora '
                    'el índice de precios.'),
                backgroundColor: AppColors.successGreen,
              ),
            );
            context.pop();
          } else if (state is BuyerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final submitting = state is BuyerReportSubmitting;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¿Viste un precio en el mercado?',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Compártelo con tu comunidad. Los reportes alimentan '
                    'el precio promedio de tu zona.',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  const Text('Producto', style: AppTextStyles.titleSmall),
                  const SizedBox(height: 8),
                  Autocomplete<String>(
                    initialValue:
                        TextEditingValue(text: _productController.text),
                    optionsBuilder: (value) {
                      if (value.text.isEmpty) return _commonProducts;
                      return _commonProducts.where(
                        (p) => p
                            .toLowerCase()
                            .contains(value.text.toLowerCase()),
                      );
                    },
                    onSelected: (v) => _productController.text = v,
                    fieldViewBuilder:
                        (context, controller, focusNode, onSubmit) {
                      // Sincroniza el controller interno del Autocomplete
                      // con el del formulario.
                      controller.addListener(
                        () => _productController.text = controller.text,
                      );
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Ej. tomate',
                        ),
                        validator: (v) =>
                            Validators.validateRequired(v, 'el producto'),
                      );
                    },
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
                            const Text(
                              'Precio observado',
                              style: AppTextStyles.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [PriceInputFormatter()],
                              decoration: const InputDecoration(
                                prefixText: 'Q ',
                                hintText: '0.00',
                              ),
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
                            const Text(
                              'Unidad',
                              style: AppTextStyles.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: _unit,
                              items: _units
                                  .map(
                                    (u) => DropdownMenuItem(
                                      value: u,
                                      child: Text(u),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _unit = v ?? 'lb'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿Dónde lo viste?',
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _zoneController,
                    decoration: const InputDecoration(
                      hintText: 'Ej. Mercado Central, Zona 1',
                    ),
                    validator: (v) =>
                        Validators.validateRequired(v, 'el lugar'),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitting ? null : _submit,
                      child: submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Enviar reporte'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Los reportes son anónimos.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textHint),
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
