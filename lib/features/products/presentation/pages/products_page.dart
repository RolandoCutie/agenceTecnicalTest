import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecases/get_products_paginated.dart';
import '../stores/products_store.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductsStore _store;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final repo = ProductRepositoryImpl();
    _store = ProductsStore(GetProductsPaginated(repo));
    _store.loadInitial();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _store.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: Observer(
          builder: (_) => NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (n) {
              n.disallowIndicator();
              return false;
            },
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _store.items.length + (_store.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _store.items.length) {
                  _store.loadMore();
                  return const Center(child: CircularProgressIndicator());
                }
                final p = _store.items[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                (p.thumbnailUrl != null &&
                                    p.thumbnailUrl!.isNotEmpty)
                                ? (p.thumbnailUrl!.startsWith('assets/')
                                      ? Image.asset(
                                          p.thumbnailUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          p.thumbnailUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Image.asset(
                                            'assets/images/product_thumbail.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ))
                                : Image.asset(
                                    'assets/images/product_thumbail.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
