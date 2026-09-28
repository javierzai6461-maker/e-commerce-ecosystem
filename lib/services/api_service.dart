import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/products_response.dart';
import '../utils/constants.dart';

class ApiException implements Exception {
  final String message;
  final bool isConnectionError;

  ApiException(this.message, {this.isConnectionError = false});

  @override
  String toString() => message;
}

class ApiService {
  /// Fetches products with pagination support.
  /// [skip] is the number of products to skip (offset).
  /// [limit] is the number of products to fetch.
  Future<ProductsResponse> getProducts({
    int skip = 0,
    int limit = pageSize,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/products?limit=$limit&skip=$skip');
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return ProductsResponse.fromJson(data);
      } else {
        throw ApiException(
          'Failed to load products (${response.statusCode})',
        );
      }
    } on SocketException {
      throw ApiException(
        'No internet connection. Please check your network.',
        isConnectionError: true,
      );
    } on http.ClientException {
      throw ApiException(
        'No internet connection. Please check your network.',
        isConnectionError: true,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// Searches products by query with pagination.
  Future<ProductsResponse> searchProducts({
    required String query,
    int skip = 0,
    int limit = pageSize,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/products/search?q=${Uri.encodeComponent(query)}&limit=$limit&skip=$skip',
      );
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return ProductsResponse.fromJson(data);
      } else {
        throw ApiException(
          'Failed to search products (${response.statusCode})',
        );
      }
    } on SocketException {
      throw ApiException(
        'No internet connection. Please check your network.',
        isConnectionError: true,
      );
    } on http.ClientException {
      throw ApiException(
        'No internet connection. Please check your network.',
        isConnectionError: true,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// Fetches a single product by ID.
  Future<Product> getProduct(int id) async {
    try {
      final url = Uri.parse('$baseUrl/products/$id');
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Product.fromJson(data);
      } else {
        throw ApiException(
          'Failed to load product (${response.statusCode})',
        );
      }
    } on SocketException {
      throw ApiException(
        'No internet connection. Please check your network.',
        isConnectionError: true,
      );
    } on http.ClientException {
      throw ApiException(
        'No internet connection. Please check your network.',
        isConnectionError: true,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
