// ---------------------------------------------------------------------------
// Punto de entrada a los datos mock de toda la app.
//
// MercadoCercano funciona SIN backend cuando `AppConstants.useMockData`
// es `true` (lib/core/constants/app_constants.dart). Cada feature tiene
// su propio datasource mock con estado en memoria, registrado en su
// `*_provider.dart`:
//
//  - Auth (lib/features/auth/data/datasources/auth_mock_datasource.dart):
//    cualquier teléfono de 8 dígitos, OTP válido `123456`, tokens fake.
//  - Vendedor (lib/features/vendor/data/...): 25 productos en 5
//    categorías con precios reales de Guatemala, stats con 7 días de
//    vistas; crear/editar/agotar/renovar funcionan de verdad en memoria.
//  - Comprador (lib/features/buyer/data/...): 5 vendedores con nombres
//    guatemaltecos y ~20 productos georreferenciados alrededor de
//    Ciudad de Guatemala; los filtros de búsqueda se aplican de verdad.
//  - Precios (lib/features/price_index/data/...): índice de 15 productos
//    de canasta básica, historial de 90 días (tomate/papa/pollo con
//    series suaves), alertas CRUD en memoria.
//  - Mapa (lib/features/map/data/...): 6-8 pins alrededor de la capital
//    + WebSocket simulado (Stream.periodic) con movimiento de
//    vendedores ambulantes.
//  - Reputación (lib/features/reputation/data/...): 10 reseñas en
//    español guatemalteco.
//
// Este archivo re-exporta los mocks para poder explorarlos o usarlos en
// tests desde un único import.
// ---------------------------------------------------------------------------

export '../../features/auth/data/datasources/auth_mock_datasource.dart';
export '../../features/buyer/data/datasources/buyer_mock_datasource.dart';
export '../../features/map/data/datasources/map_mock_datasource.dart';
export '../../features/price_index/data/datasources/price_mock_datasource.dart';
export '../../features/reputation/data/datasources/reputation_remote_datasource.dart'
    show MockReputationRemoteDatasource;
export '../../features/vendor/data/datasources/vendor_mock_datasource.dart';
export '../../features/vendor/data/mock/mock_vendor_data.dart';
