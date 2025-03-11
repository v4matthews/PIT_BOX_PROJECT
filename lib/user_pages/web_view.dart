import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String reservationId;
  final int amount;

  const WebViewPage({
    Key? key,
    required this.reservationId,
    required this.amount,
  }) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoading = false;
  String? _paymentUrl;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('payment_success')) {
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            } else if (request.url.contains('payment_failed')) {
              Navigator.pop(context, 'failed');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    _processPayment();
  }

  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.processPayment(
        reservationId: widget.reservationId,
        amount: widget.amount,
      );

      print('Response Web: $response');
      setState(() {
        _paymentUrl = response['redirect_url'];
        print('Payment URL: $_paymentUrl');
        if (_paymentUrl != null) {
          _controller.loadRequest(Uri.parse(_paymentUrl!));
        }
      });
      if (response['status'] == 'success') {
        // Handle success case if needed
      } else {
        print('Payment failed: ${response['message']}');
      }
    } catch (e) {
      print('Payment exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _paymentUrl != null
              ? WebViewWidget(controller: _controller)
              : Center(child: Text('Gagal memuat halaman pembayaran')),
    );
  }
}
