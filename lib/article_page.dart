import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'article_model.dart';
import 'article_service.dart';
import 'article_detail_page.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final ArticleService _articleService = ArticleService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Article> _articles = [];
  bool _isLoading = true;
  bool _isLoadMoreLoading = false;
  String _selectedPortal = 'ks';
  String? _errorMessage;

  int _currentPage = 1;
  int _totalPages = 1;

  final List<Map<String, String>> _portals = [
    {'id': 'ks', 'name': 'Konsultasi Syariah'},
    {'id': 'ms', 'name': 'Muslim.or.id'},
    {'id': 'msh', 'name': 'Muslimah.or.id'},
    {'id': 'maf', 'name': 'Muslimafiyah.com'},
    {'id': 'kj', 'name': 'Khotbah Jumat'},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadArticles();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && !_isLoadMoreLoading && _currentPage < _totalPages) {
        _loadMoreArticles();
      }
    }
  }

  Future<void> _loadArticles({String? query, bool isRefresh = false}) async {
    if (!isRefresh) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    
    _currentPage = 1;
    
    try {
      final result = await _articleService.getArticles(
        _selectedPortal,
        page: _currentPage,
        query: query ?? _searchController.text,
      );
      
      if (mounted) {
        setState(() {
          _articles = result['articles'] ?? [];
          _totalPages = result['totalPages'] ?? 1;
          _isLoading = false;
          if (result['success'] == false) {
            _errorMessage = result['error'] ?? 'Gagal memuat artikel';
          } else {
            _errorMessage = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Terjadi kesalahan saat memuat artikel';
        });
      }
    }
  }

  Future<void> _loadMoreArticles() async {
    setState(() => _isLoadMoreLoading = true);
    
    int nextPage = _currentPage + 1;
    try {
      final result = await _articleService.getArticles(
        _selectedPortal,
        page: nextPage,
        query: _searchController.text,
      );
      
      if (mounted) {
        setState(() {
          final List<Article> newArticles = result['articles'] ?? [];
          _articles.addAll(newArticles);
          _currentPage = nextPage;
          _totalPages = result['totalPages'] ?? 1;
          _isLoadMoreLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadMoreLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13A884);
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Artikel & Berita Islam',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(115),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Cari artikel...',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white30 : Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: primaryGreen),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 18, color: isDarkMode ? Colors.white70 : Colors.black54),
                            onPressed: () {
                              _searchController.clear();
                              FocusScope.of(context).unfocus();
                              _loadArticles();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onSubmitted: (value) => _loadArticles(query: value),
                  onChanged: (value) {
                    setState(() {}); // Update to show/hide clear icon
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, bottom: 12),
                child: Row(
                  children: _portals.map((portal) {
                    final isSelected = _selectedPortal == portal['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(portal['name']!),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedPortal = portal['id']!;
                              _searchController.clear();
                            });
                            _loadArticles();
                          }
                        },
                        selectedColor: primaryGreen,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        elevation: isSelected ? 2 : 0,
                        pressElevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected ? primaryGreen : (isDarkMode ? Colors.white10 : Colors.grey[300]!),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off, size: 80, color: isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          _selectedPortal == 'cs' || _selectedPortal == 'rum'
                              ? 'Portal ini sedang mengalami gangguan.'
                              : 'Gagal memuat artikel.',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedPortal == 'cs' || _selectedPortal == 'rum'
                              ? 'Server API untuk portal ini mengembalikan respon error (500/502). Silakan coba portal lain.'
                              : _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _loadArticles(),
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                        )
                      ],
                    ),
                  ),
                )
              : _articles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined, size: 80, color: isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada artikel ditemukan',
                            style: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[600], fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadArticles(),
                            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                            child: const Text('Refresh', style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _loadArticles(isRefresh: true),
                      color: primaryGreen,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _articles.length + (_isLoadMoreLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _articles.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(color: primaryGreen),
                              ),
                            );
                          }
                          
                          final article = _articles[index];
                          final portalInfo = _portals.firstWhere(
                            (p) => p['id'] == _selectedPortal,
                            orElse: () => {'name': article.type},
                          );
                          final sourceName = portalInfo['name'] ?? article.type;

                          return ArticleCard(
                            article: article,
                            portalId: _selectedPortal,
                            sourceName: sourceName,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetailPage(
                                      portalId: _selectedPortal,
                                      articleId: article.id,
                                      articleTitle: article.title,
                                      articleUrl: article.url,
                                      articleSource: sourceName,
                                    ),
                                  ),
                                );
                            },
                          );
                        },
                      ),
                    ),
    );
  }

}

class ArticleCard extends StatefulWidget {
  final Article article;
  final String portalId;
  final String sourceName;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.portalId,
    required this.sourceName,
    required this.onTap,
  });

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  String? _lazyThumbnail;
  bool _isLoadingDetail = false;

  @override
  void initState() {
    super.initState();
    _checkAndFetchThumbnail();
  }

  @override
  void didUpdateWidget(ArticleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.article.id != widget.article.id || oldWidget.portalId != widget.portalId) {
      _checkAndFetchThumbnail();
    }
  }

  void _checkAndFetchThumbnail() {
    if (widget.article.thumbnail.isNotEmpty) {
      if (mounted) {
        setState(() {
          _lazyThumbnail = widget.article.thumbnail;
          _isLoadingDetail = false;
        });
      }
      return;
    }

    final cached = ArticleService.detailCache[widget.article.id];
    if (cached != null) {
      if (mounted) {
        setState(() {
          _lazyThumbnail = cached['thumbnail']?.toString() ?? '';
          _isLoadingDetail = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingDetail = true;
        _lazyThumbnail = null;
      });
    }

    ArticleService().getArticleDetail(widget.portalId, widget.article.id).then((detail) {
      if (mounted) {
        setState(() {
          _isLoadingDetail = false;
          if (detail != null) {
            _lazyThumbnail = detail['thumbnail']?.toString() ?? '';
          }
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _isLoadingDetail = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13A884);
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: _buildImageSection(primaryGreen, isDarkMode),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryGreen.withOpacity(isDarkMode ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.sourceName,
                          style: const TextStyle(
                            color: primaryGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (widget.article.date.isNotEmpty)
                        Text(
                          widget.article.date.trim(),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.article.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.article.author.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Penulis: ${widget.article.author.trim()}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (widget.article.categories.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.article.categories.map((cat) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Baca Selengkapnya',
                        style: TextStyle(
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: primaryGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Color primaryGreen, bool isDarkMode) {
    if (_lazyThumbnail != null && _lazyThumbnail!.isNotEmpty) {
      return Image.network(
        _lazyThumbnail!,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderImage(widget.article.categories, widget.sourceName, isDarkMode),
      );
    }

    if (_isLoadingDetail) {
      return Container(
        height: 180,
        width: double.infinity,
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[100],
        child: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: primaryGreen,
            ),
          ),
        ),
      );
    }

    return _buildPlaceholderImage(widget.article.categories, widget.sourceName, isDarkMode);
  }

  Widget _buildPlaceholderImage(List<String> categories, String sourceName, bool isDarkMode) {
    String tagText = categories.isNotEmpty ? categories.first : sourceName;
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode 
              ? [const Color(0xFF0F362C), const Color(0xFF0C5441)]
              : [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 50, color: const Color(0xFF13A884).withOpacity(isDarkMode ? 0.3 : 0.5)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF13A884).withOpacity(isDarkMode ? 0.2 : 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tagText,
              style: const TextStyle(
                color: Color(0xFF13A884),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
