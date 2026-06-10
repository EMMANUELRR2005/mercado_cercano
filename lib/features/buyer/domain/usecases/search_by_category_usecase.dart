import '../../../../core/errors/failure.dart';
import '../entities/search_filters.dart';
import '../repositories/buyer_repository.dart';

/// Busca productos cercanos por texto, categoría y filtros.
class SearchByCategoryUsecase {
  const SearchByCategoryUsecase(this._repository);

  final BuyerRepository _repository;

  Future<(Failure?, List<SearchResult>?)> call({
    String? query,
    SearchFilters filters = const SearchFilters(),
  }) {
    return _repository.searchProducts(query: query, filters: filters);
  }
}
