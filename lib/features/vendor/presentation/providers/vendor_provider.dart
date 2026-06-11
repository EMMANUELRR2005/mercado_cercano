import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/core_providers.dart';
import '../../data/datasources/vendor_firestore_datasource.dart';
import '../../data/datasources/vendor_profile_datasource.dart';
import '../../data/datasources/vendor_remote_datasource.dart';
import '../../data/repositories/vendor_repository_impl.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/get_my_products_usecase.dart';
import '../../domain/usecases/get_vendor_stats_usecase.dart';
import '../../domain/usecases/mark_sold_out_usecase.dart';
import '../../domain/usecases/renew_all_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/watch_my_products_usecase.dart';
import '../bloc/vendor_bloc.dart';

/// DI del feature del vendedor (Riverpod 3, `Provider<T>` manual).
///
/// `vendorProductsBlocProvider` y `vendorStatsBlocProvider` son
/// autoDispose: viven mientras alguna pantalla del vendedor los observe.

/// Datasource del vendedor: Firestore (producción) o API REST propia.
final vendorRemoteDatasourceProvider = Provider<VendorRemoteDatasource>((ref) {
  if (AppConstants.useFirestore) {
    return VendorFirestoreDatasource(
      ref.watch(firestoreServiceProvider),
      ref.watch(secureStorageProvider),
      ref.watch(firebaseStorageServiceProvider),
    );
  }
  return VendorRemoteDatasourceImpl(client: ref.watch(dioClientProvider));
});

/// Perfil público del negocio (`vendors/{uid}`): Firestore + Storage.
final vendorProfileDatasourceProvider =
    Provider<VendorProfileDatasource>((ref) {
  return FirestoreVendorProfileDatasource(
    ref.watch(firestoreServiceProvider),
    ref.watch(secureStorageProvider),
    ref.watch(firebaseStorageServiceProvider),
  );
});

/// Repositorio del panel del vendedor.
final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  return VendorRepositoryImpl(
    datasource: ref.watch(vendorRemoteDatasourceProvider),
  );
});

// --- Usecases ---

final getMyProductsUsecaseProvider = Provider<GetMyProductsUsecase>((ref) {
  return GetMyProductsUsecase(ref.watch(vendorRepositoryProvider));
});

final watchMyProductsUsecaseProvider =
    Provider<WatchMyProductsUsecase>((ref) {
  return WatchMyProductsUsecase(ref.watch(vendorRepositoryProvider));
});

final createProductUsecaseProvider = Provider<CreateProductUsecase>((ref) {
  return CreateProductUsecase(ref.watch(vendorRepositoryProvider));
});

final updateProductUsecaseProvider = Provider<UpdateProductUsecase>((ref) {
  return UpdateProductUsecase(ref.watch(vendorRepositoryProvider));
});

final markSoldOutUsecaseProvider = Provider<MarkSoldOutUsecase>((ref) {
  return MarkSoldOutUsecase(ref.watch(vendorRepositoryProvider));
});

final renewAllProductsUsecaseProvider =
    Provider<RenewAllProductsUsecase>((ref) {
  return RenewAllProductsUsecase(ref.watch(vendorRepositoryProvider));
});

final getVendorStatsUsecaseProvider = Provider<GetVendorStatsUsecase>((ref) {
  return GetVendorStatsUsecase(ref.watch(vendorRepositoryProvider));
});

// --- BLoCs ---

/// BLoC del catálogo del vendedor (lista + crear/editar/agotar/renovar).
final vendorProductsBlocProvider =
    Provider.autoDispose<VendorProductsBloc>((ref) {
  final bloc = VendorProductsBloc(
    getMyProducts: ref.watch(getMyProductsUsecaseProvider),
    watchMyProducts: ref.watch(watchMyProductsUsecaseProvider),
    activityLogger: ref.watch(activityLoggerProvider),
    createProduct: ref.watch(createProductUsecaseProvider),
    updateProduct: ref.watch(updateProductUsecaseProvider),
    markSoldOut: ref.watch(markSoldOutUsecaseProvider),
    renewAllProducts: ref.watch(renewAllProductsUsecaseProvider),
  );
  ref.onDispose(bloc.close);
  return bloc;
});

/// BLoC de las estadísticas del negocio.
final vendorStatsBlocProvider = Provider.autoDispose<VendorStatsBloc>((ref) {
  final bloc = VendorStatsBloc(
    getVendorStats: ref.watch(getVendorStatsUsecaseProvider),
  );
  ref.onDispose(bloc.close);
  return bloc;
});
