import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/firebase/activity_logger.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../domain/entities/product_draft.dart';
import '../../domain/entities/vendor_stats_entity.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/get_my_products_usecase.dart';
import '../../domain/usecases/get_vendor_stats_usecase.dart';
import '../../domain/usecases/mark_sold_out_usecase.dart';
import '../../domain/usecases/renew_all_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/watch_my_products_usecase.dart';

part 'vendor_event.dart';
part 'vendor_state.dart';

/// BLoC del catálogo del vendedor (lista + mutaciones).
///
/// Convención de errores: los usecases/repositorio LANZAN excepciones;
/// este BLoC es el único punto donde se capturan y se mapean a `Failure`
/// (mensajes en español) con `mapAppException` / `mapDioException`.
///
/// Mientras haya una lista cargada, los errores de ACCIONES no la
/// destruyen: se emite [VendorProductActionFailure] conservando los
/// productos para que la UI siga siendo usable.
class VendorProductsBloc
    extends Bloc<VendorProductsEvent, VendorProductsState> {
  VendorProductsBloc({
    required this._getMyProducts,
    required this._watchMyProducts,
    required this._createProduct,
    required this._updateProduct,
    required this._markSoldOut,
    required this._renewAllProducts,
    this._activityLogger,
  }) : super(const VendorProductsInitial()) {
    on<MyProductsRequested>(_onMyProductsRequested);
    on<MyProductsWatchStarted>(_onMyProductsWatchStarted);
    on<ProductCreated>(_onProductCreated);
    on<ProductUpdated>(_onProductUpdated);
    on<ProductMarkedSoldOut>(_onProductMarkedSoldOut);
    on<ProductRenewed>(_onProductRenewed);
    on<RenewAllRequested>(_onRenewAllRequested);
  }

  final GetMyProductsUsecase _getMyProducts;
  final WatchMyProductsUsecase _watchMyProducts;
  final CreateProductUsecase _createProduct;
  final UpdateProductUsecase _updateProduct;
  final MarkSoldOutUsecase _markSoldOut;
  final RenewAllProductsUsecase _renewAllProducts;

  /// Auditoría best-effort de las acciones del vendedor.
  final ActivityLogger? _activityLogger;

  /// Lista actual si el estado la tiene; lista vacía en caso contrario.
  List<ProductEntity> get _currentProducts => switch (state) {
        VendorProductsReady(:final products) => products,
        _ => const <ProductEntity>[],
      };

  /// Evita doble suscripción al stream del catálogo (el handler de un
  /// mismo tipo de evento procesa en serie: una segunda suscripción
  /// quedaría encolada para siempre).
  bool _watching = false;

  // -------------------------------------------------------------------------
  // Handlers
  // -------------------------------------------------------------------------

  /// Catálogo en tiempo real: cada snapshot re-emite la lista.
  Future<void> _onMyProductsWatchStarted(
    MyProductsWatchStarted event,
    Emitter<VendorProductsState> emit,
  ) async {
    if (_watching) return;
    _watching = true;
    if (state is! VendorProductsReady) {
      emit(const VendorProductsLoading());
    }
    try {
      await emit.forEach<List<ProductEntity>>(
        _watchMyProducts(),
        onData: VendorProductsLoaded.new,
        onError: (error, _) {
          final message = _messageOf(error);
          final products = _currentProducts;
          return products.isEmpty
              ? VendorProductsError(message)
              : VendorProductActionFailure(products, message: message);
        },
      );
    } finally {
      // El stream terminó (o el bloc se cerró): permitir re-suscribirse.
      _watching = false;
    }
  }

  Future<void> _onMyProductsRequested(
    MyProductsRequested event,
    Emitter<VendorProductsState> emit,
  ) async {
    // Solo mostramos el loading de pantalla completa si no hay datos
    // previos (en pull-to-refresh la lista sigue visible).
    if (state is! VendorProductsReady) {
      emit(const VendorProductsLoading());
    }
    try {
      final products = await _getMyProducts();
      emit(VendorProductsLoaded(products));
    } catch (e) {
      final message = _messageOf(e);
      final previous = _currentProducts;
      if (previous.isEmpty) {
        emit(VendorProductsError(message));
      } else {
        // Refresh fallido: conservamos la lista anterior.
        emit(VendorProductActionFailure(previous, message: message));
      }
    }
  }

  Future<void> _onProductCreated(
    ProductCreated event,
    Emitter<VendorProductsState> emit,
  ) async {
    final previous = _currentProducts;
    emit(VendorProductActionInProgress(previous));
    try {
      final created = await _createProduct(event.draft);
      emit(VendorProductActionSuccess(
        [created, ...previous],
        message: '¡Producto publicado!',
        createdProduct: created,
      ));
      unawaited(_activityLogger?.log(
        ActivityAction.productCreated,
        metadata: {'productId': created.id, 'name': created.name},
      ));
    } catch (e) {
      emit(VendorProductActionFailure(previous, message: _messageOf(e)));
    }
  }

  Future<void> _onProductUpdated(
    ProductUpdated event,
    Emitter<VendorProductsState> emit,
  ) async {
    final previous = _currentProducts;
    emit(VendorProductActionInProgress(previous));
    try {
      final updated = await _updateProduct(event.product);
      emit(VendorProductActionSuccess(
        _replace(previous, updated),
        message: 'Producto actualizado',
      ));
    } catch (e) {
      emit(VendorProductActionFailure(previous, message: _messageOf(e)));
    }
  }

  Future<void> _onProductMarkedSoldOut(
    ProductMarkedSoldOut event,
    Emitter<VendorProductsState> emit,
  ) async {
    final previous = _currentProducts;
    emit(VendorProductActionInProgress(previous));
    try {
      final updated = await _markSoldOut(event.productId);
      emit(VendorProductActionSuccess(
        _replace(previous, updated),
        message: 'Producto marcado como agotado',
      ));
      unawaited(_activityLogger?.log(
        ActivityAction.productSoldOut,
        metadata: {'productId': updated.id},
      ));
    } catch (e) {
      emit(VendorProductActionFailure(previous, message: _messageOf(e)));
    }
  }

  Future<void> _onProductRenewed(
    ProductRenewed event,
    Emitter<VendorProductsState> emit,
  ) async {
    final previous = _currentProducts;
    final index = previous.indexWhere((p) => p.id == event.productId);
    if (index == -1) return;

    emit(VendorProductActionInProgress(previous));
    try {
      // Renovar = 24 h completas de vigencia a partir de ahora.
      final renewed = await _updateProduct(
        previous[index].copyWith(
          expiresAt: DateTime.now().add(
            const Duration(hours: AppConstants.productExpiryHours),
          ),
        ),
      );
      emit(VendorProductActionSuccess(
        _replace(previous, renewed),
        message: 'Producto renovado por 24 horas más',
      ));
    } catch (e) {
      emit(VendorProductActionFailure(previous, message: _messageOf(e)));
    }
  }

  Future<void> _onRenewAllRequested(
    RenewAllRequested event,
    Emitter<VendorProductsState> emit,
  ) async {
    final previous = _currentProducts;
    emit(VendorProductActionInProgress(previous));
    try {
      final products = await _renewAllProducts();
      emit(VendorProductActionSuccess(
        products,
        message: 'Todos tus productos fueron renovados por 24 horas más',
      ));
      unawaited(_activityLogger?.log(
        ActivityAction.productRenewed,
        metadata: {'count': products.length},
      ));
    } catch (e) {
      emit(VendorProductActionFailure(previous, message: _messageOf(e)));
    }
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  /// Reemplaza el producto con el mismo id dentro de la lista.
  List<ProductEntity> _replace(
    List<ProductEntity> products,
    ProductEntity updated,
  ) {
    return [
      for (final p in products)
        if (p.id == updated.id) updated else p,
    ];
  }

  String _messageOf(Object error) {
    return switch (error) {
      AppException e => mapAppException(e).message,
      DioException e => mapDioException(e).message,
      _ => 'Ocurrió un error inesperado. Intenta de nuevo.',
    };
  }
}

/// BLoC de las estadísticas del negocio del vendedor.
class VendorStatsBloc extends Bloc<VendorStatsEvent, VendorStatsState> {
  VendorStatsBloc({required this._getVendorStats})
      : super(const VendorStatsInitial()) {
    on<StatsRequested>(_onStatsRequested);
  }

  final GetVendorStatsUsecase _getVendorStats;

  Future<void> _onStatsRequested(
    StatsRequested event,
    Emitter<VendorStatsState> emit,
  ) async {
    // En recargas conservamos las métricas previas visibles.
    if (state is! VendorStatsLoaded) {
      emit(const VendorStatsLoading());
    }
    try {
      final stats = await _getVendorStats();
      emit(VendorStatsLoaded(stats));
    } catch (e) {
      emit(VendorStatsError(switch (e) {
        AppException ex => mapAppException(ex).message,
        DioException ex => mapDioException(ex).message,
        _ => 'Ocurrió un error inesperado. Intenta de nuevo.',
      }));
    }
  }
}
