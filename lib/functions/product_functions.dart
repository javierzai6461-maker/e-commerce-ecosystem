import '../models/product.dart';
import '../models/products_response.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

/// Handles all product-related business logic.
/// UI screens call these functions instead of directly using ApiService.
class ProductFunctions {
  final ApiService _apiService = ApiService();

  /// Fetches a paginated list of products.
  Future<ProductsResponse> fetchProducts({
    int skip = 0,
    int limit = pageSize,
  }) async {
    return await _apiService.getProducts(skip: skip, limit: limit);
  }

  /// Searches products by query with pagination.
  Future<ProductsResponse> searchProducts({
    required String query,
    int skip = 0,
    int limit = pageSize,
  }) async {
    return await _apiService.searchProducts(
      query: query,
      skip: skip,
      limit: limit,
    );
  }

  /// Fetches a single product by ID.
  Future<Product> fetchProductById(int id) async {
    return await _apiService.getProduct(id);
  }
}
