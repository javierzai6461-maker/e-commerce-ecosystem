import 'package:flutter/foundation.dart';
import '../functions/favourites_functions.dart';

class FavouritesProvider with ChangeNotifier {
  final FavouritesFunctions _favouritesFunctions = FavouritesFunctions();

  Set<int> _favouriteIds = {};

  Set<int> get favouriteIds => _favouriteIds;

  bool isFavourite(int productId) => _favouriteIds.contains(productId);

  /// Loads favourites from local storage via functions layer.
  Future<void> loadFavourites() async {
    _favouriteIds = await _favouritesFunctions.loadFavourites();
    notifyListeners();
  }

  /// Toggles a product's favourite status.
  Future<void> toggleFavourite(int productId) async {
    if (_favouriteIds.contains(productId)) {
      _favouriteIds.remove(productId);
    } else {
      _favouriteIds.add(productId);
    }
    notifyListeners();
    await _favouritesFunctions.saveFavourites(_favouriteIds);
  }
}
