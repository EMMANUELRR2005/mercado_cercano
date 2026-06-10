import '../../../../core/constants/app_constants.dart';
import '../models/product_model.dart';
import '../models/vendor_stats_model.dart';

/// Datos semilla del modo demo del vendedor (`AppConstants.useMockData`).
///
/// 25 productos del vendedor `mock_user_1` con nombres y precios
/// realistas del comercio informal de Guatemala (2026). Las fechas de
/// vencimiento se generan RELATIVAS al momento de carga para que la demo
/// siempre tenga productos "por vencer" (banner "Renovar todo").
class MockVendorData {
  MockVendorData._();

  /// Id del vendedor demo (coincide con el usuario mock de auth).
  static const String vendorId = 'mock_user_1';

  /// Genera los 25 productos semilla con vencimientos relativos a [now].
  static List<ProductModel> seedProducts([DateTime? now]) {
    final reference = now ?? DateTime.now();
    var index = 0;

    ProductModel item({
      required String name,
      required String category,
      required double price,
      required String unit,
      required double hoursLeft,
      bool isAvailable = true,
      bool isFeatured = false,
      int viewCount = 0,
      int clickCount = 0,
      String? description,
    }) {
      index++;
      final expiresAt = reference.add(
        Duration(minutes: (hoursLeft * 60).round()),
      );
      // El producto "nació" 24 h antes de su vencimiento.
      final createdAt = expiresAt.subtract(
        const Duration(hours: AppConstants.productExpiryHours),
      );
      return ProductModel(
        id: 'mock_prod_$index',
        vendorId: vendorId,
        name: name,
        category: category,
        price: price,
        photoUrl: 'https://picsum.photos/seed/$index/400/300',
        isAvailable: isAvailable,
        expiresAt: expiresAt,
        createdAt: createdAt,
        viewCount: viewCount,
        clickCount: clickCount,
        isFeatured: isFeatured,
        description: description,
        unit: unit,
      );
    }

    return [
      // --- Frutas y verduras (7) ---
      item(
        name: 'Tomate de cocina',
        category: 'fruitsVegetables',
        price: 5.00,
        unit: 'lb',
        hoursLeft: 1.5, // por vencer: dispara el banner "Renovar todo"
        viewCount: 182,
        clickCount: 47,
        description: 'Tomate fresco de Palín, ideal para recado.',
      ),
      item(
        name: 'Aguacate criollo',
        category: 'fruitsVegetables',
        price: 5.00,
        unit: 'unidad',
        hoursLeft: 20,
        isFeatured: true,
        viewCount: 240,
        clickCount: 63,
      ),
      item(
        name: 'Cebolla blanca',
        category: 'fruitsVegetables',
        price: 4.00,
        unit: 'lb',
        hoursLeft: 16,
        viewCount: 96,
        clickCount: 21,
      ),
      item(
        name: 'Papa grande',
        category: 'fruitsVegetables',
        price: 4.50,
        unit: 'lb',
        hoursLeft: 12,
        isAvailable: false, // agotado
        viewCount: 88,
        clickCount: 19,
      ),
      item(
        name: 'Banano de seda',
        category: 'fruitsVegetables',
        price: 1.25,
        unit: 'unidad',
        hoursLeft: 1.8, // por vencer
        viewCount: 64,
        clickCount: 12,
      ),
      item(
        name: 'Güisquil sazón',
        category: 'fruitsVegetables',
        price: 3.00,
        unit: 'unidad',
        hoursLeft: 18,
        viewCount: 41,
        clickCount: 8,
      ),
      item(
        name: 'Cilantro fresco',
        category: 'fruitsVegetables',
        price: 2.50,
        unit: 'manojo',
        hoursLeft: 0.75, // por vencer (parpadeo <30 min al acercarse)
        viewCount: 53,
        clickCount: 10,
      ),

      // --- Carnes (4) ---
      item(
        name: 'Pollo entero fresco',
        category: 'meats',
        price: 26.00,
        unit: 'lb',
        hoursLeft: 22,
        isFeatured: true,
        viewCount: 210,
        clickCount: 58,
        description: 'Pollo de granja destazado el mismo día.',
      ),
      item(
        name: 'Carne molida de res',
        category: 'meats',
        price: 38.00,
        unit: 'lb',
        hoursLeft: 19,
        viewCount: 134,
        clickCount: 35,
      ),
      item(
        name: 'Costilla de cerdo',
        category: 'meats',
        price: 32.00,
        unit: 'lb',
        hoursLeft: 14,
        viewCount: 102,
        clickCount: 24,
      ),
      item(
        name: 'Carne para hilachas',
        category: 'meats',
        price: 40.00,
        unit: 'lb',
        hoursLeft: 10,
        viewCount: 76,
        clickCount: 15,
      ),

      // --- Comida preparada (5) ---
      item(
        name: 'Tostadas de salsa y guacamol',
        category: 'preparedFood',
        price: 10.00,
        unit: 'porción',
        hoursLeft: 1.2, // por vencer
        viewCount: 158,
        clickCount: 49,
        description: 'Tres tostadas surtidas con queso y perejil.',
      ),
      item(
        name: 'Tamales colorados de pollo',
        category: 'preparedFood',
        price: 12.00,
        unit: 'unidad',
        hoursLeft: 21,
        isFeatured: true,
        viewCount: 195,
        clickCount: 61,
      ),
      item(
        name: 'Chuchitos',
        category: 'preparedFood',
        price: 6.00,
        unit: 'unidad',
        hoursLeft: 8,
        isAvailable: false, // agotado
        viewCount: 147,
        clickCount: 40,
      ),
      item(
        name: 'Atol de elote',
        category: 'preparedFood',
        price: 8.00,
        unit: 'porción',
        hoursLeft: 6,
        viewCount: 89,
        clickCount: 22,
      ),
      item(
        name: 'Rellenitos de plátano',
        category: 'preparedFood',
        price: 5.00,
        unit: 'unidad',
        hoursLeft: 9,
        viewCount: 71,
        clickCount: 16,
      ),

      // --- Granos (4) ---
      item(
        name: 'Frijol negro de primera',
        category: 'grains',
        price: 7.00,
        unit: 'lb',
        hoursLeft: 23,
        viewCount: 124,
        clickCount: 30,
      ),
      item(
        name: 'Maíz blanco',
        category: 'grains',
        price: 5.00,
        unit: 'lb',
        hoursLeft: 17,
        viewCount: 67,
        clickCount: 13,
      ),
      item(
        name: 'Arroz blanco',
        category: 'grains',
        price: 6.50,
        unit: 'lb',
        hoursLeft: 15,
        viewCount: 59,
        clickCount: 11,
      ),
      item(
        name: 'Lenteja',
        category: 'grains',
        price: 9.00,
        unit: 'lb',
        hoursLeft: 11,
        viewCount: 38,
        clickCount: 6,
      ),

      // --- Lácteos (5) ---
      item(
        name: 'Queso fresco de capas',
        category: 'dairy',
        price: 35.00,
        unit: 'lb',
        hoursLeft: 20,
        isFeatured: true,
        viewCount: 176,
        clickCount: 52,
        description: 'Queso artesanal de Zacapa.',
      ),
      item(
        name: 'Crema pura de rancho',
        category: 'dairy',
        price: 25.00,
        unit: 'porción',
        hoursLeft: 13,
        viewCount: 93,
        clickCount: 20,
      ),
      item(
        name: 'Queso seco duro',
        category: 'dairy',
        price: 45.00,
        unit: 'lb',
        hoursLeft: 7,
        isAvailable: false, // agotado
        viewCount: 81,
        clickCount: 17,
      ),
      item(
        name: 'Requesón',
        category: 'dairy',
        price: 22.00,
        unit: 'lb',
        hoursLeft: 5,
        viewCount: 44,
        clickCount: 7,
      ),
      item(
        name: 'Huevos de patio',
        category: 'dairy',
        price: 60.00,
        unit: 'docena',
        hoursLeft: 19,
        viewCount: 112,
        clickCount: 28,
      ),
    ];
  }

  /// Métricas demo coherentes con [seedProducts]:
  /// los contadores agregados se calculan sobre la lista viva del mock
  /// para que la pantalla de estadísticas refleje las acciones del demo.
  static VendorStatsModel buildStats(List<ProductModel> products) {
    final now = DateTime.now();
    final active = products
        .where((p) => p.isAvailable && p.expiresAt.isAfter(now))
        .length;
    final soldOut = products.where((p) => !p.isAvailable).length;
    final totalViews =
        products.fold<int>(0, (sum, p) => sum + p.viewCount);
    final totalClicks =
        products.fold<int>(0, (sum, p) => sum + p.clickCount);

    // Top 3 más vistos.
    final sorted = [...products]
      ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
    final topProducts = sorted.take(3).toList();

    // Serie de 7 días con una curva realista (suben fines de semana).
    const dailyViews = [132, 148, 121, 167, 189, 203, 178];
    final today = DateTime(now.year, now.month, now.day);
    final viewsByDay = List<DailyViewsModel>.generate(7, (i) {
      return DailyViewsModel(
        date: today.subtract(Duration(days: 6 - i)),
        views: dailyViews[i],
      );
    });

    return VendorStatsModel(
      totalViews: totalViews,
      totalClicks: totalClicks,
      activeProducts: active,
      soldOutProducts: soldOut,
      viewsByDay: viewsByDay,
      topProducts: topProducts,
      averageRating: 4.6,
    );
  }
}
