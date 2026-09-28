import 'package:flutter/foundation.dart';
import '../functions/recent_searches_functions.dart';

class RecentSearchesProvider with ChangeNotifier {
  final RecentSearchesFunctions _searchesFunctions = RecentSearchesFunctions();

  List<String> _searches = [];

  List<String> get searches => List.unmodifiable(_searches);

  /// Loads recent searches from local storage via functions layer.
  Future<void> loadSearches() async {
    _searches = await _searchesFunctions.loadSearches();
    notifyListeners();
  }

  /// Adds a search query. Moves duplicates to the top. Caps at 5 entries.
  Future<void> addSearch(String query) async {
    _searches = _searchesFunctions.addSearch(_searches, query);
    notifyListeners();
    await _searchesFunctions.saveSearches(_searches);
  }

  /// Clears all recent searches.
  Future<void> clearSearches() async {
    _searches.clear();
    notifyListeners();
    await _searchesFunctions.saveSearches(_searches);
  }
}
