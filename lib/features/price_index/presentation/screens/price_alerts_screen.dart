import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/price_bloc.dart';
import '../providers/price_provider.dart';

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

/// Alertas de precio (acceso libre para compradores). Cuerpo del shell
/// `/buyer/alerts`.
class PriceAlertsScreen extends ConsumerStatefulWidget {
  const PriceAlertsScreen({super.key});

  @override
  ConsumerState<PriceAlertsScreen> createState() => _PriceAlertsScreenState();
}

class _PriceAlertsScreenState extends ConsumerState<PriceAlertsScreen> {
  late final PriceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = createPriceBloc(ref)..add(const PriceAlertsRequested());
    // Permiso de notificaciones EN CONTEXTO: el usuario entró a Alertas,
    // que solo tienen sentido con notificaciones (no se pide al arrancar).
    ref.read(pushNotificationServiceProvider).ensurePermissionAndRegister();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _openCreateSheet() async {
    final created = await showModalBottomSheet<({String name, double price})>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _CreateAlertSheet(),
    );
    if (created != null) {
      _bloc.add(
        PriceAlertCreated(
          productName: created.name,
          targetPrice: created.price,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas de precio')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: _openCreateSheet,
        child: const Icon(Icons.add_alert),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: BlocConsumer<PriceBloc, PriceState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is PriceError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.errorRed,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return switch (state) {
                  PriceLoading() || PriceInitial() => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  PriceError(:final message) => ErrorStateWidget(
                    message: message,
                    onRetry: () => _bloc.add(const PriceAlertsRequested()),
                  ),
                  PriceAlertsLoaded(:final alerts) =>
                    alerts.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.notifications_none,
                            title: 'Sin alertas todavía',
                            subtitle:
                                'Crea una alerta y te avisaremos cuando '
                                'el precio baje de tu objetivo.',
                            actionLabel: 'Crear alerta de precio',
                            onAction: _openCreateSheet,
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: alerts.length,
                            itemBuilder: (context, i) => _AlertTile(
                              alert: alerts[i],
                              onToggle: () =>
                                  _bloc.add(PriceAlertToggled(alerts[i].id)),
                              onDelete: () =>
                                  _bloc.add(PriceAlertDeleted(alerts[i].id)),
                            ),
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

class _AlertTile extends StatelessWidget {
  const _AlertTile({
    required this.alert,
    required this.onToggle,
    required this.onDelete,
  });

  final PriceAlert alert;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(alert.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        onDelete();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Alerta eliminada')));
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.errorRed,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(
            alert.isActive
                ? Icons.notifications_active
                : Icons.notifications_off,
            color: alert.isActive ? AppColors.accentAmber : AppColors.textHint,
          ),
          title: Text(alert.productName, style: AppTextStyles.titleSmall),
          subtitle: Text(
            'Avisar si baja de '
            '${Formatters.formatQuetzal(alert.targetPrice)}',
            style: AppTextStyles.bodySmall,
          ),
          trailing: Switch(
            value: alert.isActive,
            activeThumbColor: AppColors.primaryGreen,
            onChanged: (_) => onToggle(),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet para crear una alerta; devuelve `(name, price)` por pop.
class _CreateAlertSheet extends StatefulWidget {
  const _CreateAlertSheet();

  @override
  State<_CreateAlertSheet> createState() => _CreateAlertSheetState();
}

class _CreateAlertSheetState extends State<_CreateAlertSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(context, (
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.replaceAll(',', '')),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crear alerta de precio',
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            Autocomplete<String>(
              optionsBuilder: (value) {
                if (value.text.isEmpty) return _commonProducts;
                return _commonProducts.where(
                  (p) => p.toLowerCase().contains(value.text.toLowerCase()),
                );
              },
              onSelected: (v) => _nameController.text = v,
              fieldViewBuilder: (context, controller, focusNode, _) {
                controller.addListener(
                  () => _nameController.text = controller.text,
                );
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Producto'),
                  validator: (v) =>
                      Validators.validateRequired(v, 'el producto'),
                );
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [PriceInputFormatter()],
              decoration: const InputDecoration(
                labelText: 'Precio objetivo',
                prefixText: 'Q ',
              ),
              validator: Validators.validatePrice,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Crear alerta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
