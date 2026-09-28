import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/products_response.dart';
import '../functions/product_functions.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

enum ProductListState { initial, loading, loaded, loadingMore, error, empty }

class ProductProvider with ChangeNotifier {
  final ProductFunctions _productFunctions = ProductFunctions();

  List<Product> _products = [];
  ProductListState _state = ProductListState.initial;
  String _errorMessage = '';
  bool _hasMore = true;
  int _skip = 0;
  String _searchQuery = '';
  bool _isSearching = false;

  // Getters
  List<Product> get products => _products;
  ProductListState get state => _state;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;

  /// Loads the initial set of products.
  Future<void> loadProducts() async {
    _state = ProductListState.loading;
    _isSearching = false;
    _searchQuery = '';
    _skip = 0;
    _products = [];
    notifyListeners();

    try {
      final response = await _productFunctions.fetchProducts(
        skip: 0,
        limit: pageSize,
      );
      _products = response.products;
      _hasMore = response.hasMore;
      _skip = response.products.length;
      _state = _products.isEmpty
          ? ProductListState.empty
          : ProductListState.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = ProductListState.error;
    }
    notifyListeners();
  }

  /// Loads more products for infinite scroll.
  Future<void> loadMore() async {
    if (_state == ProductListState.loadingMore || !_hasMore) return;

    _state = ProductListState.loadingMore;
    notifyListeners();

    try {
      final ProductsResponse response;
      if (_isSearching && _searchQuery.isNotEmpty) {
        response = await _productFunctions.searchProducts(
          query: _searchQuery,
          skip: _skip,
          limit: pageSize,
        );
      } else {
        response = await _productFunctions.fetchProducts(
          skip: _skip,
          limit: pageSize,
        );
      }

      _products.addAll(response.products);
      _hasMore = response.hasMore;
      _skip += response.products.length;
      _state = ProductListState.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = ProductListState.loaded; // Keep existing products visible
    }
    notifyListeners();
  }

  /// Searches products by query.
  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      await loadProducts();
      return;
    }

    _state = ProductListState.loading;
    _isSearching = true;
    _searchQuery = query.trim();
    _skip = 0;
    _products = [];
    notifyListeners();

    try {
      final response = await _productFunctions.searchProducts(
        query: _searchQuery,
        skip: 0,
        limit: pageSize,
      );
      _products = response.products;
      _hasMore = response.hasMore;
      _skip = response.products.length;
      _state = _products.isEmpty
          ? ProductListState.empty
          : ProductListState.loaded;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = ProductListState.error;
    }
    notifyListeners();
  }

  /// Refreshes the current view (pull-to-refresh).
  Future<void> refresh() async {
    if (_isSearching && _searchQuery.isNotEmpty) {
      await searchProducts(_searchQuery);
    } else {
      await loadProducts();
    }
  }
}
