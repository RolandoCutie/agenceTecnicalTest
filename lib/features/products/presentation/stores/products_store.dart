import 'package:mobx/mobx.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_paginated.dart';

part 'products_store.g.dart';

class ProductsStore = _ProductsStore with _$ProductsStore;

abstract class _ProductsStore with Store {
  final GetProductsPaginated _getProducts;
  _ProductsStore(this._getProducts);

  @observable
  ObservableList<Product> items = ObservableList<Product>();

  @observable
  bool isLoading = false;

  @observable
  bool hasMore = true;

  int _page = 0;
  final int _pageSize = 20;

  @action
  Future<void> loadInitial() async {
    items.clear();
    _page = 0;
    hasMore = true;
    await loadMore();
  }

  @action
  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    try {
      final newItems = await _getProducts(page: _page, pageSize: _pageSize);
      items.addAll(newItems);
      _page++;
      if (newItems.length < _pageSize) {
        hasMore = false;
      }
    } finally {
      isLoading = false;
    }
  }
}
