import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/vendor_location_entity.dart';
import '../models/vendor_location_model.dart';

/// Contrato del datasource de tiempo real del mapa.
///
/// PROTOCOLO REAL ESPERADO (backend): WebSocket en
/// `ws://api.mercadocercano.gt/ws/map` (AppConstants.wsUrl) con mensajes
/// JSON de dos tipos:
///
/// ```json
/// {"type": "vendor_update",  "payload": { ...VendorLocationModel... }}
/// {"type": "vendor_offline", "payload": {"vendorId": "vendor_001"}}
/// ```
///
/// `vendor_update` llega cuando un vendedor ambulante se mueve, publica
/// un precio nuevo o vuelve a estar en línea; `vendor_offline` cuando
/// cierra su puesto o pierde conexión.
abstract class MapWebsocketDatasource {
  /// Stream de eventos en vivo; los mensajes mal formados se ignoran.
  Stream<VendorRealtimeEvent> watchVendors();

  /// Cierra la conexión / cancela los timers internos.
  void dispose();
}

/// Implementación real sobre `web_socket_channel`.
class MapWebsocketDatasourceImpl implements MapWebsocketDatasource {
  MapWebsocketDatasourceImpl();

  WebSocketChannel? _channel;

  @override
  Stream<VendorRealtimeEvent> watchVendors() async* {
    final channel = WebSocketChannel.connect(Uri.parse(AppConstants.wsUrl));
    _channel = channel;

    await for (final raw in channel.stream) {
      final event = _parseMessage(raw);
      if (event != null) yield event;
    }
  }

  /// Parsea un mensaje del protocolo; devuelve null si no se reconoce.
  VendorRealtimeEvent? _parseMessage(dynamic raw) {
    try {
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is! Map<String, dynamic>) return null;

      final type = decoded['type'] as String?;
      final payload = decoded['payload'];

      switch (type) {
        case 'vendor_update':
          final model =
              VendorLocationModel.fromJson(payload as Map<String, dynamic>);
          return VendorLocationUpdated(model.toEntity());
        case 'vendor_offline':
          final vendorId = (payload as Map<String, dynamic>)['vendorId'];
          if (vendorId is String) return VendorWentOffline(vendorId);
          return null;
        default:
          return null;
      }
    } catch (_) {
      // Mensaje corrupto: se ignora para no tumbar el stream completo.
      return null;
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _channel = null;
  }
}
