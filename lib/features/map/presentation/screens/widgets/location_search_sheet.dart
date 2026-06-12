import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/datasources/place_search_service.dart';
import '../../providers/map_provider.dart';

/// Bottom sheet para buscar una dirección o lugar y usarlo como centro
/// de búsqueda del mapa. Devuelve el [PlaceResult] elegido (o null).
class LocationSearchSheet extends ConsumerStatefulWidget {
  const LocationSearchSheet({super.key});

  static Future<PlaceResult?> show(BuildContext context) {
    return showModalBottomSheet<PlaceResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LocationSearchSheet(),
    );
  }

  @override
  ConsumerState<LocationSearchSheet> createState() =>
      _LocationSearchSheetState();
}

class _LocationSearchSheetState extends ConsumerState<LocationSearchSheet> {
  final _controller = TextEditingController();

  List<PlaceResult> _results = const [];
  bool _searching = false;
  bool _searched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty || _searching) return;
    setState(() {
      _searching = true;
      _searched = true;
    });
    final results = await ref.read(placeSearchServiceProvider).search(query);
    if (!mounted) return;
    setState(() {
      _results = results;
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Deja el sheet por encima del teclado.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buscar en otra ubicación',
                  style: AppTextStyles.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Escribe una dirección, colonia o lugar. También puedes '
                'mantener presionado cualquier punto del mapa.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: 'Ej. Zona 1, Mixco, Mercado Central…',
                  prefixIcon: const Icon(Icons.place_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  suffixIcon: IconButton(
                    tooltip: 'Buscar',
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.primaryGreen,
                    ),
                    onPressed: _search,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_searching)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_results.isEmpty && _searched)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No se encontró ese lugar. Intenta con más detalle '
                    '(ej. "4a calle, Zona 1, Guatemala").',
                    style: AppTextStyles.bodySmall,
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final result = _results[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primaryGreen,
                        ),
                        title: Text(
                          result.label,
                          style: AppTextStyles.bodyMedium,
                        ),
                        onTap: () => Navigator.pop(context, result),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
