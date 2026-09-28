import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favourites_provider.dart';
import '../functions/product_functions.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final ProductFunctions _productFunctions = ProductFunctions();
  List<Product>? _favouriteProducts;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Read initial IDs once for fetching
      final favIds = context.read<FavouritesProvider>().favouriteIds;
      if (favIds.isEmpty) {
        setState(() {
          _favouriteProducts = [];
          _isLoading = false;
        });
        return;
      }

      // Fetch all favourite products simultaneously
      final products = await Future.wait(
        favIds.map((id) => _productFunctions.fetchProductById(id)),
      );

      setState(() {
        _favouriteProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load favourites. Please check your network.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Watch provider so if user un-hearts a product on this screen,
    // it dynamically disappears from the list!
    final currentFavIds = context.watch<FavouritesProvider>().favouriteIds;
    
    final displayProducts = _favouriteProducts
        ?.where((p) => currentFavIds.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favourites',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _buildBody(displayProducts, theme),
    );
  }

  Widget _buildBody(List<Product>? products, ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadFavourites,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (products == null || products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 80,
              color: theme.colorScheme.onSurface.withAlpha(50),
            ),
            const SizedBox(height: 16),
            Text(
              'No favourites yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
