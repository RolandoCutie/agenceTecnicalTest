import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> getProducts({
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final start = (page - 1) * pageSize;
    return List.generate(pageSize, (index) {
      final idx = start + index + 1;
      final thumb = 'assets/images/product_thumbnail.png';
      return Product(id: '$idx', name: 'Product $idx', thumbnailUrl: thumb);
    });
  }
}
