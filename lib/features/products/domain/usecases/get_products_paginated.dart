import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsPaginated {
  final ProductRepository repository;
  GetProductsPaginated(this.repository);

  Future<List<Product>> call({required int page, required int pageSize}) {
    return repository.getProducts(page: page, pageSize: pageSize);
  }
}
