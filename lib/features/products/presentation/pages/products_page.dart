import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/sign_in_with_facebook.dart';
import '../../../auth/domain/usecases/sign_in_with_google.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../../auth/presentation/stores/auth_store.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecases/get_products_paginated.dart';
import '../stores/products_store.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductsStore _store;
  late final AuthStore _authStore;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final repo = ProductRepositoryImpl();
    _store = ProductsStore(GetProductsPaginated(repo));
    _authStore = AuthStore(
      SignInWithGoogle(AuthRepositoryImpl()),
      SignInWithFacebook(AuthRepositoryImpl()),
      SignOut(AuthRepositoryImpl()),
    );
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
        drawer: Drawer(
          child: Observer(
            builder: (_) => ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    fb.FirebaseAuth.instance.currentUser?.displayName
                                ?.trim()
                                .isNotEmpty ==
                            true
                        ? fb.FirebaseAuth.instance.currentUser!.displayName!
                              .trim()
                        : 'Anonymous',
                  ),
                  accountEmail: null,
                  currentAccountPicture: CircleAvatar(
                    child: Text(
                      (fb.FirebaseAuth.instance.currentUser?.displayName
                                      ?.trim()
                                      .isNotEmpty ==
                                  true
                              ? fb
                                    .FirebaseAuth
                                    .instance
                                    .currentUser!
                                    .displayName!
                                    .trim()[0]
                              : 'A')
                          .toUpperCase(),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile'),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: const Text('My products'),
                  onTap: () => Navigator.pushNamed(context, '/my-products'),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign out'),
                  onTap: () async {
                    await _authStore.signOut();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: p),
                        ),
                      );
                    },
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
                                            errorBuilder: (_, _, _) => Image.asset(
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
