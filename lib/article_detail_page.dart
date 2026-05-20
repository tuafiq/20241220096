import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'article_service.dart';

class ArticleDetailPage extends StatefulWidget {
  final String portalId;
  final String articleId;
  final String articleTitle;
  final String articleUrl;
  final String articleSource;

  const ArticleDetailPage({
    super.key,
    required this.portalId,
    required this.articleId,
    required this.articleTitle,
    required this.articleUrl,
    required this.articleSource,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final ArticleService _articleService = ArticleService();
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white);
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final detail = await _articleService.getArticleDetail(widget.portalId, widget.articleId);
      if (detail != null && detail['content_html'] != null && detail['content_html'].toString().isNotEmpty) {
        
        final formattedHtml = _buildHtmlString(
          title: detail['title'] ?? widget.articleTitle,
          author: detail['author'] ?? '',
          date: detail['date'] ?? '',
          thumbnail: detail['thumbnail'] ?? '',
          contentHtml: detail['content_html'],
        );

        await _webViewController.loadHtmlString(formattedHtml);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Fallback to loading the original url directly
        await _webViewController.loadRequest(Uri.parse(widget.articleUrl));
        _webViewController.setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (error) {
              // If loading request fails, mark error
              if (mounted) {
                setState(() {
                  _isError = true;
                  _isLoading = false;
                });
              }
            },
          ),
        );
      }
    } catch (e) {
      // Fallback to loading original URL
      try {
        await _webViewController.loadRequest(Uri.parse(widget.articleUrl));
        _webViewController.setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (error) {
              if (mounted) {
                setState(() {
                  _isError = true;
                  _isLoading = false;
                });
              }
            },
          ),
        );
      } catch (innerException) {
        if (mounted) {
          setState(() {
            _isError = true;
            _isLoading = false;
          });
        }
      }
    }
  }

  String _buildHtmlString({
    required String title,
    required String author,
    required String date,
    required String thumbnail,
    required String contentHtml,
  }) {
    String imageTag = '';
    if (thumbnail.isNotEmpty) {
      final secureThumbnail = thumbnail.replaceAll('http://', 'https://');
      imageTag = '<img src="$secureThumbnail" alt="thumbnail" onerror="this.style.display=\'none\';" />';
    }
    final secureContentHtml = contentHtml
        .replaceAll('src="http://', 'src="https://')
        .replaceAll("src='http://", "src='https://");

    String authorTag = '';
    if (author.trim().isNotEmpty) {
      authorTag = '<span class="author">Oleh: $author</span>';
    }

    String dateTag = '';
    if (date.trim().isNotEmpty) {
      dateTag = '<span class="date">$date</span>';
    }

    String metaSection = '';
    if (authorTag.isNotEmpty || dateTag.isNotEmpty) {
      metaSection = '<div class="meta">$authorTag $dateTag</div>';
    }

    return '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    line-height: 1.6;
    color: #333333;
    padding: 16px;
    margin: 0;
    font-size: 16px;
    background-color: #ffffff;
  }
  h1 {
    font-size: 22px;
    font-weight: 700;
    color: #111111;
    margin-top: 0;
    margin-bottom: 12px;
    line-height: 1.3;
  }
  .meta {
    font-size: 13px;
    color: #777777;
    margin-bottom: 20px;
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    border-bottom: 1px solid #eeeeee;
    padding-bottom: 12px;
  }
  .author {
    font-weight: 500;
    color: #13A884;
  }
  .date {
    color: #888888;
  }
  img {
    max-width: 100%;
    height: auto;
    border-radius: 12px;
    margin: 16px 0;
    box-shadow: 0 4px 10px rgba(0,0,0,0.05);
  }
  a {
    color: #13A884;
    text-decoration: none;
    font-weight: 500;
  }
  p {
    margin-bottom: 16px;
    text-align: justify;
  }
  blockquote {
    border-left: 4px solid #13A884;
    padding: 8px 0 8px 16px;
    margin: 16px 0;
    color: #555555;
    background-color: #f9f9f9;
    border-radius: 0 8px 8px 0;
    font-style: italic;
  }
  ul, ol {
    padding-left: 20px;
    margin-bottom: 16px;
  }
  li {
    margin-bottom: 8px;
  }
</style>
</head>
<body>
  <h1>$title</h1>
  $metaSection
  $imageTag
  <div class="content">
    $secureContentHtml
  </div>
</body>
</html>
''';
  }

  Future<void> _shareArticle() async {
    try {
      await Share.share(
        '${widget.articleTitle}\nBaca selengkapnya di: ${widget.articleUrl}',
        subject: widget.articleTitle,
      );
    } catch (e) {
      // Ignored
    }
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(widget.articleUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membuka browser'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13A884);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.articleSource,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: _shareArticle,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser_outlined, color: Colors.black87),
            onPressed: _openInBrowser,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal memuat artikel',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Silakan periksa koneksi internet Anda atau buka artikel di browser.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _loadDetail,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                    ),
                    TextButton.icon(
                      onPressed: _openInBrowser,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Buka di Browser'),
                      style: TextButton.styleFrom(foregroundColor: primaryGreen),
                    ),
                  ],
                ),
              ),
            )
          else
            WebViewWidget(controller: _webViewController),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: primaryGreen),
            ),
        ],
      ),
    );
  }
}
