// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class MidtransWebView extends StatefulWidget {
//   final String url;

//   const MidtransWebView({Key? key, required this.url}) : super(key: key);

//   @override
//   _MidtransWebViewState createState() => _MidtransWebViewState();
// }

// class _MidtransWebViewState extends State<MidtransWebView> {
//   late WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.white)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://your-success-url.com')) {
//               // Handle successful payment
//               Navigator.of(context).pop('success');
//             } else if (request.url.startsWith('https://your-failure-url.com')) {
//               // Handle failed payment
//               Navigator.of(context).pop('failure');
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Midtrans Payment'),
//       ),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
