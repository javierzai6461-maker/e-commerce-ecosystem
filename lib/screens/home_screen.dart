import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/recent_searches_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/recent_searches_widget.dart';
import '../utils/debouncer.dart';
import 'favourites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  bool _showRecentSearches = false;

  @override
  void initState() {
    super.initState();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
      context.read<FavouritesProvider>().loadFavourites();
      context.read<RecentSearchesProvider>().loadSearches();
    });

    // Infinite scroll listener
    _scrollController.addListener(_onScroll);

    // Show/hide recent searches on focus
    _searchFocusNode.addListener(() {
      setState(() {
        _showRecentSearches = _searchFocusNode.hasFocus;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<ProductProvider>();
      if (provider.hasMore &&
          provider.state != ProductListState.loadingMore) {
        provider.loadMore();
      }
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    _searchFocusNode.unfocus();
    setState(() => _showRecentSearches = false);

    _searchController.text = query;
    context.read<RecentSearchesProvider>().addSearch(query);
    context.read<ProductProvider>().searchProducts(query);
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      if (query.trim().isEmpty) {
        context.read<ProductProvider>().loadProducts();
      } else {
        context.read<ProductProvider>().searchProducts(query);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() => _showRecentSearches = false);
    context.read<ProductProvider>().loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar area (fixed height, not flexible)
            _buildAppBar(theme),
            // Search bar (fixed height, not flexible)
            _buildSearchBar(theme),
            // Content area takes remaining space
            Expanded(
              child: Stack(
                children: [
                  // Main content fills the expanded area
                  Positioned.fill(
                    child: _buildBody(theme),
                  ),
                  // Recent searches overlay on top of content
                  if (_showRecentSearches)
                    Positioned(
                      top: 0,
                      left: 16,
                      right: 16,
                      child: RecentSearchesWidget(
                        onSearchTap: (query) {
                          _performSearch(query);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Find products you love',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(130),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavouritesScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(50),
                  ),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.redAccent,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    final provider = context.watch<ProductProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _searchFocusNode.hasFocus
                ? theme.colorScheme.primary.withAlpha(120)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _onSearchChanged,
          onSubmitted: _performSearch,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(100),
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.onSurface.withAlpha(120),
            ),
            suffixIcon: (provider.isSearching ||
                    _searchController.text.isNotEmpty)
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: theme.colorScheme.onSurface.withAlpha(120),
                    ),
                    onPressed: _clearSearch,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final provider = context.watch<ProductProvider>();

    switch (provider.state) {
      case ProductListState.initial:
      case ProductListState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );

      case ProductListState.error:
        return AppErrorWidget(
          message: provider.errorMessage,
          onRetry: () => provider.refresh(),
        );

      case ProductListState.empty:
        return const EmptyResultsWidget();

      case ProductListState.loaded:
      case ProductListState.loadingMore:
        return RefreshIndicator(
          onRefresh: () => provider.refresh(),
          child: GridView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.products.length +
                (provider.state == ProductListState.loadingMore ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= provider.products.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return ProductCard(product: provider.products[index]);
            },
          ),
        );
    }
  }
}
