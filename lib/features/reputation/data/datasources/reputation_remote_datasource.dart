import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/rating_model.dart';
import '../models/report_model.dart';

/// Contrato del datasource remoto de reputación.
abstract class ReputationRemoteDatasource {
  /// Calificaciones de un vendedor, más recientes primero.
  Future<List<RatingModel>> getVendorRatings(String vendorId);

  /// Envía una calificación; el backend asigna id y buyerId (del token).
  Future<RatingModel> submitRating({
    required String vendorId,
    required double stars,
    String? comment,
  });

  /// Envía un reporte de fraude.
  Future<ReportModel> reportFraud({
    required String vendorId,
    required String reason,
    String? description,
  });
}

/// Implementación real contra la API de MercadoCercano.
class ReputationRemoteDatasourceImpl implements ReputationRemoteDatasource {
  ReputationRemoteDatasourceImpl(this._client);

  final DioClient _client;

  @override
  Future<List<RatingModel>> getVendorRatings(String vendorId) async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.ratings,
      queryParameters: {'vendorId': vendorId},
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al obtener calificaciones');
    }
    return data
        .map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RatingModel> submitRating({
    required String vendorId,
    required double stars,
    String? comment,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.ratings,
      data: {
        'vendorId': vendorId,
        'stars': stars,
        'comment': ?comment,
      },
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al enviar calificación');
    }
    return RatingModel.fromJson(data);
  }

  @override
  Future<ReportModel> reportFraud({
    required String vendorId,
    required String reason,
    String? description,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.reportsFraud,
      data: {
        'vendorId': vendorId,
        'reason': reason,
        'description': ?description,
      },
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al enviar reporte');
    }
    return ReportModel.fromJson(data);
  }
}

/// Implementación MOCK: funciona sin backend (AppConstants.useMockData).
///
/// Mantiene las calificaciones en memoria, con 10 reseñas semilla
/// escritas como hablaría la gente en los mercados de Guatemala.
class MockReputationRemoteDatasource implements ReputationRemoteDatasource {
  MockReputationRemoteDatasource();

  static const _delay = Duration(milliseconds: 500);

  final List<RatingModel> _ratings = _seedRatings();
  final List<ReportModel> _reports = [];

  static List<RatingModel> _seedRatings() {
    final now = DateTime.now();
    return [
      RatingModel(
        id: 'rat_001',
        vendorId: 'vendor_001',
        buyerId: 'buyer_010',
        stars: 5,
        comment: 'Muy buen precio, el tomate bien fresco. Sí recomiendo.',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      RatingModel(
        id: 'rat_002',
        vendorId: 'vendor_001',
        buyerId: 'buyer_011',
        stars: 4.5,
        comment: 'La señora muy amable, hasta me regaló cilantro de yapa.',
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      RatingModel(
        id: 'rat_003',
        vendorId: 'vendor_001',
        buyerId: 'buyer_012',
        stars: 4,
        comment: 'Buenos güisquiles, aunque a veces se acaban temprano.',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      RatingModel(
        id: 'rat_004',
        vendorId: 'vendor_001',
        buyerId: 'buyer_013',
        stars: 5,
        comment: 'El aguacate estaba en su punto, qué chilero. Volveré.',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      RatingModel(
        id: 'rat_005',
        vendorId: 'vendor_001',
        buyerId: 'buyer_014',
        stars: 3,
        comment: 'Bien, pero el precio del limón subió bastante esta semana.',
        createdAt: now.subtract(const Duration(days: 3, hours: 5)),
      ),
      RatingModel(
        id: 'rat_006',
        vendorId: 'vendor_002',
        buyerId: 'buyer_015',
        stars: 5,
        comment: 'Las tortillas calientitas y a buen precio, de a tres por Q1.',
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      RatingModel(
        id: 'rat_007',
        vendorId: 'vendor_002',
        buyerId: 'buyer_016',
        stars: 4,
        comment: 'Don Chema siempre pesa cabal, eso se agradece.',
        createdAt: now.subtract(const Duration(days: 1, hours: 9)),
      ),
      RatingModel(
        id: 'rat_008',
        vendorId: 'vendor_002',
        buyerId: 'buyer_017',
        stars: 4.5,
        comment: 'Frijol parado de buena calidad, mejor precio que en el súper.',
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      RatingModel(
        id: 'rat_009',
        vendorId: 'vendor_003',
        buyerId: 'buyer_018',
        stars: 2,
        comment: 'Me cobraron más de lo que decía el cartel, ojo con eso.',
        createdAt: now.subtract(const Duration(days: 5, hours: 1)),
      ),
      RatingModel(
        id: 'rat_010',
        vendorId: 'vendor_003',
        buyerId: 'buyer_019',
        stars: 5,
        comment: 'Excelente atención y el queso fresco buenísimo, patojos amables.',
        createdAt: now.subtract(const Duration(days: 6)),
      ),
    ];
  }

  @override
  Future<List<RatingModel>> getVendorRatings(String vendorId) async {
    await Future<void>.delayed(_delay);
    // Si el vendedor no tiene reseñas propias, devolvemos un set genérico
    // para que cualquier vendorId de demo muestre contenido.
    final own = _ratings.where((r) => r.vendorId == vendorId).toList();
    final result = own.isNotEmpty
        ? own
        : _ratings.map((r) => r.copyWith(vendorId: vendorId)).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  @override
  Future<RatingModel> submitRating({
    required String vendorId,
    required double stars,
    String? comment,
  }) async {
    await Future<void>.delayed(_delay);
    final rating = RatingModel(
      id: 'rat_${DateTime.now().millisecondsSinceEpoch}',
      vendorId: vendorId,
      buyerId: 'buyer_local',
      stars: stars,
      comment: comment,
      createdAt: DateTime.now(),
    );
    _ratings.insert(0, rating);
    return rating;
  }

  @override
  Future<ReportModel> reportFraud({
    required String vendorId,
    required String reason,
    String? description,
  }) async {
    await Future<void>.delayed(_delay);
    final report = ReportModel(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      vendorId: vendorId,
      reason: reason,
      description: description,
      createdAt: DateTime.now(),
    );
    _reports.add(report);
    return report;
  }
}
