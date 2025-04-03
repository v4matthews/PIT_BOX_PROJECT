import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/user_pages/user_dashboard.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final ValueChanged<String>? onUrlChanged;
  final VoidCallback? onPaymentSuccess;
  final VoidCallback? onPaymentFailed;

  const WebViewPage({
    Key? key,
    required this.url,
    this.onUrlChanged,
    this.onPaymentSuccess,
    this.onPaymentFailed,
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  var _loadingProgress = 0;
  var _isLoading = true;
  var _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(_createNavigationDelegate())
      ..loadRequest(Uri.parse(widget.url));
  }

  NavigationDelegate _createNavigationDelegate() {
    return NavigationDelegate(
      onProgress: (int progress) {
        setState(() {
          _loadingProgress = progress;
          _isLoading = progress < 100;
        });
        debugPrint('Loading progress: $progress%');
      },
      onPageStarted: (String url) {
        widget.onUrlChanged?.call(url);
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
        debugPrint('Page started loading: $url');
      },
      onPageFinished: (String url) {
        widget.onUrlChanged?.call(url);
        setState(() {
          _isLoading = false;
        });
        debugPrint('Page finished loading: $url');

        // Cek status pembayaran setelah page selesai load
        _checkPaymentStatus(url);
      },
      onWebResourceError: (WebResourceError error) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
        debugPrint('''
          WebView Error:
          Code: ${error.errorCode}
          Description: ${error.description}
          Type: ${error.errorType}
          URL: ${error.url}
        ''');
      },
      onNavigationRequest: (NavigationRequest request) {
        debugPrint('Navigation request to: ${request.url}');

        // Handle URL khusus untuk callback Midtrans
        if (_handlePaymentCallback(request.url)) {
          return NavigationDecision.prevent;
        }

        // Izinkan navigasi untuk URL lainnya
        return NavigationDecision.navigate;
      },
    );
  }

  bool _handlePaymentCallback(String url) {
    final uri = Uri.parse(url);
    debugPrint('Handling payment callback for URL: $url');

    // Handle berdasarkan path dan query parameters
    if (uri.path.contains('/payment/success')) {
      widget.onPaymentSuccess?.call();
      _navigateToDashboard();
      return true;
    } else if (uri.path.contains('/payment/failed')) {
      widget.onPaymentFailed?.call();
      _navigateToDashboard();
      return true;
    }
    // Handle callback langsung dari Midtrans
    else if (uri.queryParameters.containsKey('transaction_status')) {
      final status = uri.queryParameters['transaction_status'];
      final orderId = uri.queryParameters['order_id'];
      debugPrint('Midtrans callback - Status: $status, Order ID: $orderId');

      if (status == 'settlement' || status == 'capture') {
        widget.onPaymentSuccess?.call();
        _navigateToDashboard();
        return true;
      } else if (status == 'deny' || status == 'cancel' || status == 'expire') {
        widget.onPaymentFailed?.call();
        _navigateToDashboard();
        return true;
      }
    }

    return false;
  }

  void _checkPaymentStatus(String url) {
    final uri = Uri.parse(url);
    final status = uri.queryParameters['status'];

    if (status == 'success') {
      widget.onPaymentSuccess?.call();
      _navigateToDashboard();
    } else if (status == 'failed') {
      widget.onPaymentFailed?.call();
      _navigateToDashboard();
    }
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    } else {
      // Jika pengguna menutup halaman pembayaran, arahkan ke halaman Dashboard
      _navigateToDashboard();
      return true;
    }
  }

  void _navigateToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserDashboard()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Pembayaran',
            style: TextStyle(
              color: AppColors.whiteText,
              fontSize: 18,
              fontFamily: 'OpenSans',
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
            onPressed: () async {
              if (await _controller.canGoBack()) {
                await _controller.goBack();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: _loadingProgress / 100,
                    strokeWidth: 2,
                    color: AppColors.whiteText,
                  ),
                ),
              ),
          ],
        ),
        body: _buildWebViewContent(),
      ),
    );
  }

  Widget _buildWebViewContent() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat halaman pembayaran',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _initializeWebViewController();
                });
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading && _loadingProgress < 100)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: _loadingProgress / 100,
                ),
                const SizedBox(height: 16),
                Text(
                  'Memuat halaman pembayaran... $_loadingProgress%',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
