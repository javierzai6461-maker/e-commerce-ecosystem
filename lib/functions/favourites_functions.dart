import 'package:shared_preferences/shared_preferences.dart';

/// Handles favourites persistence logic.
/// UI providers call these functions instead of directly using SharedPreferences.
class FavouritesFunctions {
  static const String _storageKey = 'favourite_product_ids';

  /// Loads favourite product IDs from local storage.
  Future<Set<int>> loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey);
    if (stored != null) {
      return stored.map((e) => int.parse(e)).toSet();
    }
    return {};
  }

  /// Saves favourite product IDs to local storage.
  Future<void> saveFavourites(Set<int> favouriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      favouriteIds.map((e) => e.toString()).toList(),
    );
  }
}
