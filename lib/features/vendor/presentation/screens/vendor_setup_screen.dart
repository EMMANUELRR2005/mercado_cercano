import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/firebase/activity_logger.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_image.dart';
import '../../domain/entities/vendor_profile.dart';
import '../providers/vendor_provider.dart';

/// Configuración del negocio del vendedor: foto, nombre, ubicación y
/// referencia. Se muestra al elegir el rol Vendedor y es editable
/// después desde el header del panel (ícono de lápiz).
class VendorSetupScreen extends ConsumerStatefulWidget {
  const VendorSetupScreen({super.key});

  @override
  ConsumerState<VendorSetupScreen> createState() =>
      _VendorSetupScreenState();
}

class _VendorSetupScreenState extends ConsumerState<VendorSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _referenceController = TextEditingController();
  final _picker = ImagePicker();

  /// Ruta local de la foto recién elegida (aún sin subir).
  String? _pickedPhotoPath;

  /// URL de la foto ya guardada (al editar un perfil existente).
  String? _existingPhotoUrl;

  LatLng? _coordinates;
  String? _neighborhood;
  bool _saving = false;
  bool _loadingLocation = false;
  bool _loadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  /// Precarga el perfil si ya existe (modo edición).
  Future<void> _loadExistingProfile() async {
    try {
      final profile =
          await ref.read(vendorProfileDatasourceProvider).getMyProfile();
      if (!mounted) return;
      if (profile != null) {
        _nameController.text = profile.businessName;
        // El doc guarda "+502XXXXXXXX"; el campo edita solo los 8 dígitos.
        _phoneController.text =
            (profile.phone ?? '').replaceAll(RegExp(r'\D'), '').replaceFirst(
                  RegExp(r'^502'),
                  '',
                );
        _referenceController.text = profile.locationReference ?? '';
        _existingPhotoUrl = profile.photoUrl;
        _neighborhood = profile.neighborhood;
        if (profile.latitude != null && profile.longitude != null) {
          _coordinates = LatLng(profile.latitude!, profile.longitude!);
        }
      }
    } catch (_) {
      // Sin perfil previo: pantalla en blanco para configurar.
    } finally {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  // -----------------------------------------------------------------
  // Foto
  // -----------------------------------------------------------------

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera,
                  color: AppColors.primaryGreen),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: AppColors.primaryGreen),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 80,
      );
      if (picked != null && mounted) {
        setState(() => _pickedPhotoPath = picked.path);
      }
    } catch (_) {
      // En simulador la cámara puede no existir.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir la cámara/galería'),
          ),
        );
      }
    }
  }

  // -----------------------------------------------------------------
  // Ubicación
  // -----------------------------------------------------------------

  /// Reverse geocoding: coordenadas → "colonia, zona/municipio".
  Future<void> _resolveNeighborhood(LatLng position) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final place = placemarks.firstOrNull;
      if (place == null) return;
      final parts = [
        if ((place.subLocality ?? '').isNotEmpty) place.subLocality!,
        if ((place.locality ?? '').isNotEmpty) place.locality!,
      ];
      if (mounted && parts.isNotEmpty) {
        setState(() => _neighborhood = parts.join(', '));
      }
    } catch (_) {
      // El geocoder puede no estar disponible (simulador/sin red):
      // la coordenada basta y la referencia manual cubre el resto.
      if (mounted && _neighborhood == null) {
        setState(() => _neighborhood = 'Ubicación seleccionada');
      }
    }
  }

  /// Opción 1: GPS del dispositivo.
  Future<void> _useCurrentLocation() async {
    setState(() => _loadingLocation = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const ValidationException(
          'Sin permiso de ubicación. Usa "Seleccionar en el mapa".',
        );
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final coordinates = LatLng(position.latitude, position.longitude);
      setState(() => _coordinates = coordinates);
      await _resolveNeighborhood(coordinates);
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mapAppException(e).message),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener tu ubicación. '
                'Usa "Seleccionar en el mapa".'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  /// Opción 2: pin arrastrable en un mini mapa.
  Future<void> _pickOnMap() async {
    final initial = _coordinates ??
        const LatLng(
          AppConstants.guatemalaCityLat,
          AppConstants.guatemalaCityLng,
        );
    final selected = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => _MapPickerScreen(initial: initial),
      ),
    );
    if (selected != null) {
      setState(() => _coordinates = selected);
      await _resolveNeighborhood(selected);
    }
  }

  // -----------------------------------------------------------------
  // Guardar
  // -----------------------------------------------------------------

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_coordinates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Indica la ubicación de tu negocio'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(vendorProfileDatasourceProvider).saveProfile(
            VendorProfile(
              businessName: _nameController.text.trim(),
              phone: '+502${_phoneController.text.trim()}',
              photoUrl: _existingPhotoUrl,
              latitude: _coordinates!.latitude,
              longitude: _coordinates!.longitude,
              neighborhood: _neighborhood,
              locationReference:
                  _referenceController.text.trim().isEmpty
                      ? null
                      : _referenceController.text.trim(),
            ),
            localPhotoPath: _pickedPhotoPath,
          );
      // Auditoría best-effort.
      unawaited(
        ref
            .read(activityLoggerProvider)
            .log(ActivityAction.vendorSetupCompleted),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Tu negocio quedó configurado! 🏪'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      context.go(RouteNames.vendorHomePath);
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mapAppException(e).message),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // -----------------------------------------------------------------
  // UI
  // -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi negocio')),
      body: _loadingProfile
          ? const Center(
              child:
                  CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Foto del negocio ---
                    Center(
                      child: GestureDetector(
                        onTap: _pickPhoto,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 56,
                              backgroundColor: AppColors.divider,
                              foregroundImage: _photoProvider(),
                              child: const Icon(
                                Icons.storefront,
                                size: 44,
                                color: AppColors.textHint,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.photo_camera,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        'Foto de tu negocio',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Nombre de la tienda ---
                    const Text('Nombre de la tienda',
                        style: AppTextStyles.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      maxLength: 50,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText:
                            'Ej: Verduras Don Pedro, Carnes La Terminal…',
                      ),
                      validator: (v) => Validators.validateRequired(
                          v, 'el nombre de tu tienda'),
                    ),
                    const SizedBox(height: 16),

                    // --- Número de contacto ---
                    const Text('Número de contacto',
                        style: AppTextStyles.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        // Prefijo fijo de Guatemala (visual, no editable).
                        prefixText: '+502 ',
                        hintText: 'Ej: 55551234',
                        helperText:
                            'Los compradores te llamarán o escribirán '
                            'por WhatsApp a este número.',
                        helperMaxLines: 2,
                      ),
                      validator: (v) {
                        final digits = (v ?? '').trim();
                        if (digits.isEmpty) {
                          return 'Ingresa tu número de contacto';
                        }
                        if (!RegExp(r'^\d{8}$').hasMatch(digits)) {
                          return 'El número debe tener exactamente 8 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- Ubicación ---
                    const Text('Ubicación del negocio',
                        style: AppTextStyles.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed:
                                _loadingLocation ? null : _useCurrentLocation,
                            icon: _loadingLocation
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.my_location),
                            label: const Text('Mi ubicación'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickOnMap,
                            icon: const Icon(Icons.map_outlined),
                            label: const Text('En el mapa'),
                          ),
                        ),
                      ],
                    ),
                    if (_coordinates != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.place,
                              size: 18, color: AppColors.primaryGreen),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _neighborhood ?? 'Ubicación seleccionada',
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),

                    // --- Referencia manual (opcional) ---
                    const Text('Referencia (opcional)',
                        style: AppTextStyles.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _referenceController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText:
                            'Ej: Puesto 34, pasillo B, Mercado La Terminal',
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Guardar y empezar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Foto elegida (archivo local) o ya guardada (URL/base64/ruta local).
  ImageProvider? _photoProvider() =>
      appImageProvider(_pickedPhotoPath ?? _existingPhotoUrl);
}

/// Mini mapa de pantalla completa para elegir la ubicación del negocio.
///
/// El pin es un ícono FIJO al centro de la pantalla (no un Marker): la
/// selección es siempre el centro de la cámara, así se mantiene centrado
/// mientras el usuario mueve y hace zoom. Devuelve la coordenada con
/// `Navigator.pop`.
class _MapPickerScreen extends StatefulWidget {
  const _MapPickerScreen({required this.initial});

  final LatLng initial;

  @override
  State<_MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<_MapPickerScreen> {
  GoogleMapController? _controller;

  /// Selección = último centro de la cámara (sin setState: el pin es
  /// fijo en pantalla y no hay nada más que repintar).
  late LatLng _selected = widget.initial;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _zoom(double delta) {
    _controller?.animateCamera(
      delta > 0 ? CameraUpdate.zoomIn() : CameraUpdate.zoomOut(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('¿Dónde está tu negocio?')),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.pop(context, _selected),
        icon: const Icon(Icons.check),
        label: const Text('Confirmar ubicación'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: widget.initial, zoom: 16),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            scrollGesturesEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(5.0, 20.0),
            onMapCreated: (controller) => _controller = controller,
            // La selección sigue al centro de la cámara.
            onCameraMove: (position) => _selected = position.target,
            // Tocar el mapa centra la cámara (y el pin) en ese punto.
            onTap: (position) => _controller?.animateCamera(
              CameraUpdate.newLatLng(position),
            ),
          ),

          // Pin fijo al centro: la punta toca el centro exacto del mapa,
          // por eso se desplaza hacia arriba la mitad de su altura.
          IgnorePointer(
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -22),
                child: const Icon(
                  Icons.place,
                  size: 44,
                  color: AppColors.errorRed,
                ),
              ),
            ),
          ),

          // Botones manuales de zoom (esquina inferior derecha).
          Positioned(
            right: 16,
            bottom: 96,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PickerZoomButton(
                  icon: Icons.add,
                  tooltip: 'Acercar',
                  onTap: () => _zoom(1),
                ),
                const SizedBox(height: 4),
                _PickerZoomButton(
                  icon: Icons.remove,
                  tooltip: 'Alejar',
                  onTap: () => _zoom(-1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón cuadrado 40×40 con sombra suave para el zoom del mini mapa.
class _PickerZoomButton extends StatelessWidget {
  const _PickerZoomButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 20, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
