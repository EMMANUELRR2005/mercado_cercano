/// Perfil público del negocio del vendedor (doc `vendors/{uid}`).
///
/// Clase simple (sin freezed): es un objeto de formulario con pocos
/// campos y sin serialización JSON directa.
class VendorProfile {
  const VendorProfile({
    required this.businessName,
    this.phone,
    this.photoUrl,
    this.latitude,
    this.longitude,
    this.neighborhood,
    this.locationReference,
    this.setupCompleted = false,
  });

  /// Nombre de la tienda (máx. 50 caracteres).
  final String businessName;

  /// Número de contacto en formato internacional (`+502XXXXXXXX`).
  /// Lo usan los botones Llamar/WhatsApp del mapa del comprador.
  final String? phone;

  /// URL de la foto del negocio (Storage) o ruta local en modo demo.
  final String? photoUrl;

  final double? latitude;
  final double? longitude;

  /// Zona/colonia aproximada (reverse geocoding o texto).
  final String? neighborhood;

  /// Referencia manual: "Puesto 34, pasillo B, Mercado La Terminal".
  final String? locationReference;

  /// True cuando el vendedor completó la pantalla de configuración.
  final bool setupCompleted;

  VendorProfile copyWith({
    String? businessName,
    String? phone,
    String? photoUrl,
    double? latitude,
    double? longitude,
    String? neighborhood,
    String? locationReference,
    bool? setupCompleted,
  }) {
    return VendorProfile(
      businessName: businessName ?? this.businessName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      neighborhood: neighborhood ?? this.neighborhood,
      locationReference: locationReference ?? this.locationReference,
      setupCompleted: setupCompleted ?? this.setupCompleted,
    );
  }
}
