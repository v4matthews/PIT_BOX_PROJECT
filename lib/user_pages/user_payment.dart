import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserPaymentPage extends StatefulWidget {
  final String reservationId;
  final int amount;

  const UserPaymentPage({
    Key? key,
    required this.reservationId,
    required this.amount,
  }) : super(key: key);

  @override
  _UserPaymentPageState createState() => _UserPaymentPageState();
}

class _UserPaymentPageState extends State<UserPaymentPage> {
  bool _isLoading = false;
  String? _paymentUrl;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            print('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('allowing navigation to $request');
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

      if (response['status'] == 'success') {
        setState(() {
          _paymentUrl = response['redirect_url'];
          print('Payment URL: $_paymentUrl');
          _controller.loadRequest(Uri.parse(_paymentUrl!));
        });
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
