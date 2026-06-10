import 'package:geolocator/geolocator.dart';

import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/entities/vendor_entity.dart';
import '../models/vendor_location_model.dart';
import 'map_remote_datasource.dart';

/// Implementación MOCK del datasource del mapa (AppConstants.useMockData).
///
/// Devuelve vendedores de demo alrededor de Ciudad de Guatemala
/// (±0.02 grados del centro 14.6349, -90.5069), con precios realistas
/// en Quetzales del comercio informal.
class MockMapRemoteDatasource implements MapRemoteDatasource {
  MockMapRemoteDatasource();

  static const _delay = Duration(milliseconds: 500);

  /// Semilla compartida: el mock del WebSocket la reutiliza para emitir
  /// movimientos coherentes de los mismos vendedores.
  static final List<VendorLocationModel> seedVendors = [
    const VendorLocationModel(
      vendor: VendorEntity(
        id: 'vendor_001',
        name: 'Doña María La Bendición',
        phone: '55123456',
        whatsapp: '55123456',
        category: ProductCategory.fruitsVegetables,
        rating: 4.8,
        totalRatings: 124,
        isVerified: true,
        description:
            'Verduras frescas de Almolonga todos los días, peso cabal.',
        address: 'Mercado Central, local 23, zona 1',
      ),
      latitude: 14.6418,
      longitude: -90.5134,
      lowestPriceToday: 3.50,
      lowestPriceProductName: 'Tomate (libra)',
    ),
    const VendorLocationModel(
      vendor: VendorEntity(
        id: 'vendor_002',
        name: 'Don Carlos Carnicería',
        phone: '42987654',
        whatsapp: '42987654',
        category: ProductCategory.meats,
        rating: 4.6,
        totalRatings: 89,
        isVerified: true,
        description: 'Carne de res y marrano fresca, destace del día.',
        address: 'Mercado La Terminal, zona 4',
      ),
      latitude: 14.6212,
      longitude: -90.5217,
      lowestPriceToday: 28.00,
      lowestPriceProductName: 'Carne molida (libra)',
    ),
    const VendorLocationModel(
      vendor: VendorEntity(
        id: 'vendor_003',
        name: 'Frutas Doña Rosa',
        phone: '31456789',
        category: ProductCategory.fruitsVegetables,
        rating: 4.4,
        totalRatings: 56,
        isVerified: false,
        description: 'Fruta de temporada: papaya, mango, piña y sandía.',
      ),
      latitude: 14.6501,
      longitude: -90.4938,
      lowestPriceToday: 5.00,
      lowestPriceProductName: 'Aguacate (unidad)',
    ),
    const VendorLocationModel(
      vendor: VendorEntity(
        id: 'vendor_004',
        name: 'Comedor Tere',
        phone: '47651122',
        whatsapp: '47651122',
        category: ProductCategory.preparedFood,
        rating: 4.9,
        totalRatings: 203,
        isVerified: false,
        description: 'Almuerzos caseros: pepián, hilachas y caldo de gallina.',
        address: '6a avenida, zona 1',
      ),
      latitude: 14.6390,
      longitude: -90.5151,
      lowestPriceToday: 18.00,
      lowestPriceProductName: 'Almuerzo del día',
    ),
    const VendorLocationModel(
      vendor: VendorEntity(
        id: 'vendor_005',
        name: 'Abarrotería San Judas',
        phone: '53349087',
        category: ProductCategory.grains,
        rating: 4.2,
        totalRatings: 41,
        isVerified: false,
        description: 'Frijol, arroz, azúcar y maíz por libra o por quintal.',
      ),
      latitude: 14.6477,
      longitude: -90.5226,
      lowestPriceToday: 6.50,
      lowestPriceProductName: 'Frijol negro (libra)',
    ),
    const VendorLocationModel(
      vendor: VendorEntity(
        id: 'vendor_006',
        name: 'Tortillería La Esquina',
        phone: '40215678',
        category: ProductCategory.preparedFood,
        rating: 4.7,
        totalRatings: 167,
        isVerified: false,
        description: 'Tortillas calientitas de maíz amarillo y blanco.',
      ),
      latitude: 14.6298,
      longitude: -90.4977,
      lowestPriceToday: 3.00,
      lowestPriceProductName: 'Tortillas (docena)',
    ),
    const VendorLocationModel(
      vendor: VendorEntity(
        id: 'vendor_007',
        name: 'Lácteos El Establo',
        phone: '36784321',
        whatsapp: '36784321',
        category: ProductCategory.dairy,
        rating: 3.9,
        totalRatings: 28,
        isVerified: false,
        description: 'Queso fresco, crema y requesón de Chiquimula.',
      ),
      latitude: 14.6533,
      longitude: -90.5102,
      lowestPriceToday: 15.00,
      lowestPriceProductName: 'Queso fresco (libra)',
    ),
    const VendorLocationModel(
      vendor: VendorEntity(
        id: 'vendor_008',
        name: 'Ropa Americana Keyla',
        phone: '58904567',
        category: ProductCategory.clothing,
        rating: 3.8,
        totalRatings: 19,
        isVerified: false,
        description: 'Pacas selectas: playeras, pantalones y chumpas.',
      ),
      latitude: 14.6181,
      longitude: -90.5015,
      lowestPriceToday: 25.00,
      lowestPriceProductName: 'Playera selecta',
    ),
  ];

  @override
  Future<List<VendorLocationModel>> getVendorsNearby({
    required double lat,
    required double lng,
    required double radiusKm,
  }) async {
    await Future<void>.delayed(_delay);

    // Calcula la distancia real desde la ubicación del usuario y filtra
    // por el radio activo, igual que lo haría el backend.
    final result = seedVendors
        .map(
          (v) => v.copyWith(
            distanceMeters: Geolocator.distanceBetween(
              lat,
              lng,
              v.latitude,
              v.longitude,
            ),
          ),
        )
        .where((v) => (v.distanceMeters ?? 0) <= radiusKm * 1000)
        .toList()
      ..sort(
        (a, b) => (a.distanceMeters ?? 0).compareTo(b.distanceMeters ?? 0),
      );

    return result;
  }
}
