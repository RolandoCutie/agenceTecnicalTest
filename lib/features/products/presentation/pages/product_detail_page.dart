import 'package:flutter/material.dart';
// Usamos flutter_map (OpenStreetMap) para evitar API keys de Google
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../../domain/entities/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with WidgetsBindingObserver {
  final MapController _mapController = MapController();
  ll.LatLng? _userLatLng;
  String? _locationError;
  static const double _ringRadius = 30; // radio fijo del anillo

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // flutter_map no requiere dispose del MapController
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Cuando la app vuelve a primer plano (desde settings), reintentar ubicación
    if (state == AppLifecycleState.resumed && _userLatLng == null) {
      _initLocation();
    }
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationError = 'Location services are disabled.');
        if (mounted) {
          // Mostrar diálogo para habilitar servicios de ubicación
          // y abrir configuración del dispositivo.
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
              title: const Text('Enable Location'),
              content: const Text(
                'Location services are disabled. Please enable GPS to show your position on the map.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Geolocator.openLocationSettings();
                  },
                  child: const Text('Open settings'),
                ),
              ],
            ),
          );
        }
        return;
      }
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final req = await Geolocator.requestPermission();
        if (req == LocationPermission.denied ||
            req == LocationPermission.deniedForever) {
          setState(() => _locationError = 'Location permission denied');
          return;
        }
      } else if (permission == LocationPermission.deniedForever) {
        setState(
          () => _locationError =
              'Location permission permanently denied. Enable it from settings.',
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final latLng = ll.LatLng(pos.latitude, pos.longitude);
      setState(() => _userLatLng = latLng);
      Future.microtask(() {
        try {
          _mapController.move(latLng, 14);
        } catch (_) {}
      });
    } catch (e) {
      setState(() => _locationError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapHeight = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: Column(
        children: [
          SizedBox(height: mapHeight, child: _buildMap()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            widget.product.thumbnailUrl != null &&
                                widget.product.thumbnailUrl!.isNotEmpty
                            ? (widget.product.thumbnailUrl!.startsWith(
                                    'assets/',
                                  )
                                  ? Image.asset(
                                      widget.product.thumbnailUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      widget.product.thumbnailUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ))
                            : Image.asset(
                                'assets/images/product_thumbail.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This is a fake description for the selected product. It provides brief details and features to simulate real content.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Purchase'),
                            content: Text('Buy ${widget.product.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text('Purchase'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (_locationError != null) {
      return Center(child: Text(_locationError!));
    }
    if (_userLatLng == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: _userLatLng!, initialZoom: 14),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.agence',
            ),
            CircleLayer(
              circles: [
                CircleMarker(
                  point: _userLatLng!,
                  radius: _ringRadius,
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderColor: Colors.blue,
                  borderStrokeWidth: 2,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _userLatLng!,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.my_location, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              _mapController.move(_userLatLng!, 14);
            },
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
