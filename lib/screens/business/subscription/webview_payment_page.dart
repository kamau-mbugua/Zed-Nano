import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/contants/AppConstants.dart';

class WebViewPaymentPage extends StatefulWidget {
  final CreateBillingInvoiceResponse invoiceData;
  final String userEmail;
  final String firstName;
  final String lastName;
  final VoidCallback onPaymentComplete;
  final VoidCallback onPaymentCancelled;

  const WebViewPaymentPage({
    super.key,
    required this.invoiceData,
    required this.userEmail,
    required this.firstName,
    required this.lastName,
    required this.onPaymentComplete,
    required this.onPaymentCancelled,
  });

  @override
  State<WebViewPaymentPage> createState() => _WebViewPaymentPageState();
}

class _WebViewPaymentPageState extends State<WebViewPaymentPage> {
  late final WebViewController controller;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              errorMessage = null;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              errorMessage = 'Error loading payment page: ${error.description}';
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Listen for redirect URLs that indicate payment completion
            if (_isPaymentCompleteUrl(request.url)) {
              _handlePaymentComplete();
              return NavigationDecision.prevent;
            }
            if (_isPaymentCancelledUrl(request.url)) {
              _handlePaymentCancelled();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_buildPaymentUrl()));
  }

  String _buildPaymentUrl() {
    // Build the payment URL similar to your Kotlin implementation
    final baseUrl = AppConstants.webUrl; // Updated to use webUrl
    final amount = widget.invoiceData.amount?.toString() ?? '0';
    final invoiceId = widget.invoiceData.invoiceId ?? '';
    final invoiceNumber = widget.invoiceData.invoiceNumber ?? '';
    
    // URL encode the email
    final encodedEmail = Uri.encodeComponent(widget.userEmail);
    
    // Build the URL similar to your Kotlin pattern
    final paymentUrl = '$baseUrl/cardpay/${widget.firstName}/${widget.lastName}/$amount/invoice/$encodedEmail/$invoiceId/$invoiceNumber';
    
    print('Payment URL: $paymentUrl'); // For debugging
    return paymentUrl;
  }

  bool _isPaymentCompleteUrl(String url) {
    // Define patterns that indicate successful payment
    // Adjust these patterns based on your payment gateway's redirect URLs
    return url.contains('payment-success') || 
           url.contains('payment-complete') ||
           url.contains('success') ||
           url.contains('completed');
  }

  bool _isPaymentCancelledUrl(String url) {
    // Define patterns that indicate cancelled/failed payment
    return url.contains('payment-cancelled') ||
           url.contains('payment-failed') ||
           url.contains('cancelled') ||
           url.contains('failed');
  }

  void _handlePaymentComplete() {
    // Payment completed successfully
    widget.onPaymentComplete();
  }

  void _handlePaymentCancelled() {
    // Payment was cancelled or failed
    widget.onPaymentCancelled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            widget.onPaymentCancelled();
          },
        ),
        title: const Text(
          'Complete Payment',
          style: TextStyle(
            color: Color(0xff1f2024),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 16.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Payment Error',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          errorMessage = null;
                        });
                        _initializeWebView();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            WebViewWidget(controller: controller),
          
          // Loading indicator
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff032541)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading payment page...',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Color(0xff71727a),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
