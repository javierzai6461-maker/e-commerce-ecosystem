import 'package:shared_preferences/shared_preferences.dart';

/// Handles recent searches persistence logic.
/// UI providers call these functions instead of directly using SharedPreferences.
class RecentSearchesFunctions {
  static const String _storageKey = 'recent_searches';
  static const int maxSearches = 5;

  /// Loads recent searches from local storage.
  Future<List<String>> loadSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey);
    return stored ?? [];
  }

  /// Saves recent searches to local storage.
  Future<void> saveSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, searches);
  }

  /// Adds a search query to the list, removes duplicates, keeps max entries.
  /// Returns the updated list.
  List<String> addSearch(List<String> current, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return current;

    final updated = List<String>.from(current);
    // Remove duplicate if it exists
    updated.remove(trimmed);
    // Insert at top
    updated.insert(0, trimmed);
    // Keep only the max
    if (updated.length > maxSearches) {
      return updated.sublist(0, maxSearches);
    }
    return updated;
  }
}
