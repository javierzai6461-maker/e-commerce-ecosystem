import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recent_searches_provider.dart';

class RecentSearchesWidget extends StatelessWidget {
  final Function(String) onSearchTap;

  const RecentSearchesWidget({
    super.key,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recentSearches = context.watch<RecentSearchesProvider>();

    if (recentSearches.searches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: theme.colorScheme.shadow.withAlpha(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withAlpha(180),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => recentSearches.clearSearches(),
                    icon: Icon(
                      Icons.clear_all_rounded,
                      size: 18,
                      color: theme.colorScheme.error.withAlpha(180),
                    ),
                    label: Text(
                      'Clear',
                      style: TextStyle(
                        color: theme.colorScheme.error.withAlpha(180),
                        fontSize: 13,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
            ...recentSearches.searches.map((search) {
              return InkWell(
                onTap: () => onSearchTap(search),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 20,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          search,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withAlpha(200),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.north_west_rounded,
                        size: 16,
                        color: theme.colorScheme.outline.withAlpha(120),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
