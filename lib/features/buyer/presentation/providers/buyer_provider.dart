import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/core_providers.dart';
import '../../../price_index/presentation/providers/price_provider.dart';
import '../../data/datasources/buyer_mock_datasource.dart';
import '../../data/datasources/buyer_remote_datasource.dart';
import '../../data/repositories/buyer_repository_impl.dart';
import '../../domain/repositories/buyer_repository.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';
import '../../domain/usecases/get_vendor_detail_usecase.dart';
import '../../domain/usecases/report_price_usecase.dart';
import '../../domain/usecases/search_by_category_usecase.dart';
import '../bloc/buyer_bloc.dart';

/// DI manual con Riverpod 3 (`Provider<T>`, sin codegen) para buyer.

/// Datasource remoto: mock o real según `AppConstants.useMockData`.
///
/// El mock vive aquí (provider sin autoDispose) para que su estado en
/// memoria (vistas de producto) persista entre pantallas.
final buyerRemoteDatasourceProvider = Provider<BuyerRemoteDatasource>((ref) {
  if (AppConstants.useMockData) {
    return BuyerMockDatasource();
  }
  return BuyerRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

/// Repositorio del comprador.
final buyerRepositoryProvider = Provider<BuyerRepository>((ref) {
  return BuyerRepositoryImpl(ref.watch(buyerRemoteDatasourceProvider));
});

/// Caso de uso: buscar productos por texto/categoría/filtros.
final searchByCategoryUsecaseProvider = Provider<SearchByCategoryUsecase>(
  (ref) => SearchByCategoryUsecase(ref.watch(buyerRepositoryProvider)),
);

/// Caso de uso: detalle de producto.
final getProductDetailUsecaseProvider = Provider<GetProductDetailUsecase>(
  (ref) => GetProductDetailUsecase(ref.watch(buyerRepositoryProvider)),
);

/// Caso de uso: detalle de vendedor con catálogo.
final getVendorDetailUsecaseProvider = Provider<GetVendorDetailUsecase>(
  (ref) => GetVendorDetailUsecase(ref.watch(buyerRepositoryProvider)),
);

/// Caso de uso: reportar precio observado.
final reportPriceUsecaseProvider = Provider<ReportPriceUsecase>(
  (ref) => ReportPriceUsecase(ref.watch(buyerRepositoryProvider)),
);

/// Fábrica del BLoC del comprador.
///
/// Es `autoDispose` para cerrar el bloc cuando ya nadie lo escucha.
/// Pantallas que conviven en el stack (home → búsqueda → detalle) deben
/// crear su propia instancia con [createBuyerBloc] para no pisarse.
final buyerBlocProvider = Provider.autoDispose<BuyerBloc>((ref) {
  final bloc = BuyerBloc(
    searchByCategory: ref.watch(searchByCategoryUsecaseProvider),
    getProductDetail: ref.watch(getProductDetailUsecaseProvider),
    getVendorDetail: ref.watch(getVendorDetailUsecaseProvider),
    reportPrice: ref.watch(reportPriceUsecaseProvider),
    getIndexByZone: ref.watch(getIndexByZoneUsecaseProvider),
  );
  ref.onDispose(bloc.close);
  return bloc;
});

/// Crea una instancia NUEVA de [BuyerBloc] para una pantalla concreta.
///
/// El caller es responsable de cerrarla (`bloc.close()` en `dispose`).
BuyerBloc createBuyerBloc(WidgetRef ref) {
  return BuyerBloc(
    searchByCategory: ref.read(searchByCategoryUsecaseProvider),
    getProductDetail: ref.read(getProductDetailUsecaseProvider),
    getVendorDetail: ref.read(getVendorDetailUsecaseProvider),
    reportPrice: ref.read(reportPriceUsecaseProvider),
    getIndexByZone: ref.read(getIndexByZoneUsecaseProvider),
  );
}
