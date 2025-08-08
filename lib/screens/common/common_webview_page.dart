import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';

class CommonWebViewPage extends StatefulWidget {

  const CommonWebViewPage({
    required this.url, super.key,
    this.title,
    this.showAppBar = true,
    this.onPageFinished,
    this.onUrlChanged,
    this.onBack,
  });
  final String url;
  final String? title;
  final bool showAppBar;
  final VoidCallback? onPageFinished;
  final Function(String)? onUrlChanged;
  final VoidCallback? onBack;

  @override
  State<CommonWebViewPage> createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;
  String? errorMessage;
  String currentUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            logger.d('WebView loading progress: $progress%');
          },
          onPageStarted: (String url) {
            logger.d('Page started loading: $url');
            setState(() {
              isLoading = true;
              errorMessage = null;
              currentUrl = url;
            });
            
            // Call the onUrlChanged callback if provided
            if (widget.onUrlChanged != null) {
              widget.onUrlChanged!(url);
            }
          },
          onPageFinished: (String url) {
            logger.d('Page finished loading: $url');
            setState(() {
              isLoading = false;
              currentUrl = url;
            });
            
            // Call the onPageFinished callback if provided
            if (widget.onPageFinished != null) {
              widget.onPageFinished!();
            }
          },
          onWebResourceError: (WebResourceError error) {
            logger.e('WebView error: ${error.description}');
            setState(() {
              isLoading = false;
              errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            logger.d('Navigation request to: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AuthAppBar(title: widget.title ?? 'Terms and Conditions',
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            if (isLoading)
              const LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            
            // Error message
            if (errorMessage != null)
              Container(
                width: double.infinity,
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load page',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          errorMessage = null;
                        });
                        controller.reload();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            
            // WebView
            if (errorMessage == null)
              Expanded(
                child: WebViewWidget(controller: controller),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
