import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/domain/entities/price_entities.dart';
import '../../../price_index/domain/usecases/get_index_by_zone_usecase.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';
import '../../domain/usecases/get_vendor_detail_usecase.dart';
import '../../domain/usecases/report_price_usecase.dart';
import '../../domain/usecases/search_by_category_usecase.dart';

part 'buyer_event.dart';
part 'buyer_state.dart';

/// BLoC del comprador: home, búsqueda, detalle y reporte de precios.
class BuyerBloc extends Bloc<BuyerEvent, BuyerState> {
  BuyerBloc({
    required this._searchByCategory,
    required this._getProductDetail,
    required this._getVendorDetail,
    required this._reportPrice,
    required this._getIndexByZone,
  }) : super(const BuyerInitial()) {
    on<BuyerHomeRequested>(_onHomeRequested);
    on<BuyerSearchRequested>(_onSearchRequested);
    on<BuyerProductDetailRequested>(_onProductDetailRequested);
    on<BuyerVendorDetailRequested>(_onVendorDetailRequested);
    on<BuyerPriceReported>(_onPriceReported);
  }

  final SearchByCategoryUsecase _searchByCategory;
  final GetProductDetailUsecase _getProductDetail;
  final GetVendorDetailUsecase _getVendorDetail;
  final ReportPriceUsecase _reportPrice;
  final GetIndexByZoneUsecase _getIndexByZone;

  Future<void> _onHomeRequested(
    BuyerHomeRequested event,
    Emitter<BuyerState> emit,
  ) async {
    emit(const BuyerLoading());

    // Índice del día y resultados cercanos en paralelo (los usecases
    // nunca lanzan: devuelven records (Failure?, T?)).
    final ((indexFailure, indices), (searchFailure, searchResults)) =
        await (_getIndexByZone(), _searchByCategory()).wait;

    final failure = indexFailure ?? searchFailure;
    if (failure != null) {
      emit(BuyerError(failure.message));
      return;
    }

    // Vendedores cercanos: dedupe por id a partir de los resultados de
    // búsqueda, ordenados por distancia.
    final byVendor = <String, NearbyVendor>{};
    for (final r in searchResults ?? const <SearchResult>[]) {
      byVendor.putIfAbsent(
        r.vendor.id,
        () => NearbyVendor(vendor: r.vendor, distanceKm: r.distanceKm),
      );
    }
    final vendors = byVendor.values.toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    emit(
      BuyerHomeLoaded(
        priceIndex: indices ?? const <PriceIndex>[],
        vendors: vendors,
      ),
    );
  }

  Future<void> _onSearchRequested(
    BuyerSearchRequested event,
    Emitter<BuyerState> emit,
  ) async {
    emit(const BuyerLoading());
    final (failure, results) = await _searchByCategory(
      query: event.query,
      filters: event.filters,
    );
    if (failure != null) {
      emit(BuyerError(failure.message));
      return;
    }
    emit(
      BuyerSearchLoaded(
        results: results ?? const <SearchResult>[],
        filters: event.filters,
        query: event.query,
      ),
    );
  }

  Future<void> _onProductDetailRequested(
    BuyerProductDetailRequested event,
    Emitter<BuyerState> emit,
  ) async {
    emit(const BuyerLoading());
    final (failure, result) = await _getProductDetail(event.productId);
    if (failure != null) {
      emit(BuyerError(failure.message));
      return;
    }
    emit(BuyerProductDetailLoaded(result!));
  }

  Future<void> _onVendorDetailRequested(
    BuyerVendorDetailRequested event,
    Emitter<BuyerState> emit,
  ) async {
    emit(const BuyerLoading());
    final (failure, detail) = await _getVendorDetail(event.vendorId);
    if (failure != null) {
      emit(BuyerError(failure.message));
      return;
    }
    emit(BuyerVendorDetailLoaded(detail!));
  }

  Future<void> _onPriceReported(
    BuyerPriceReported event,
    Emitter<BuyerState> emit,
  ) async {
    emit(const BuyerReportSubmitting());
    final (failure, _) = await _reportPrice(
      productName: event.productName,
      price: event.price,
      unit: event.unit,
      zone: event.zone,
    );
    if (failure != null) {
      emit(BuyerError(failure.message));
      return;
    }
    emit(const BuyerReportSuccess());
  }
}
