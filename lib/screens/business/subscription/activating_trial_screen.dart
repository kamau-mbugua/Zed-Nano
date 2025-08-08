import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/fading_circular_progress.dart';
import 'package:zed_nano/services/websocket_service.dart';

class ActivatingTrialScreen extends StatefulWidget {

  const ActivatingTrialScreen({
    super.key,
    this.invoiceNumber,
    this.onActivationComplete,
    this.onActivationError,
  });
  final String? invoiceNumber;
  final VoidCallback? onActivationComplete;
  final Function(String)? onActivationError;

  @override
  State<ActivatingTrialScreen> createState() => _ActivatingTrialScreenState();
}

class _ActivatingTrialScreenState extends State<ActivatingTrialScreen> {
  WebSocketService? _webSocketService;
  Timer? _timeoutTimer;
  String _statusMessage = 'Please wait while we activate\nand setup your business.';
  String _userToken = '';
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    if (widget.invoiceNumber != null) {
      _initializeWebSocket();
      _startTimeoutTimer();
    }
    _userToken = getAuthProvider(context).token;
  }

  void _initializeWebSocket() {
    _webSocketService = WebSocketService();
    
    // Listen to connection status
    _webSocketService!.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
      logger.d('WebSocket connection status: $isConnected');
    });

    // Listen to messages
    _webSocketService!.messageStream.listen(_handleWebSocketMessage);

    // Connect to WebSocket
    _webSocketService!.connect(widget.invoiceNumber!,userToken:_userToken);
  }

  void _handleWebSocketMessage(WsResponse wsResponse) {
    if (!mounted) return;

    logger.d('Trial activation message: ${wsResponse.status} - ${wsResponse.statusMessage}');

    switch (wsResponse.status?.toLowerCase()) {
      case 'activating':
        setState(() {
          _statusMessage = 'Activating your trial plan...';
        });
        
      case 'setting_up':
        setState(() {
          _statusMessage = 'Setting up your business...';
        });
        
      case 'success':
      case 'activated':
        setState(() {
          _statusMessage = 'Trial activated successfully!';
        });
        showCustomToast('Trial activated successfully!', isError: false);
        
        // Call success callback after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          widget.onActivationComplete?.call();
        });
        
      case 'error':
      case 'failed':
        final errorMessage = wsResponse.statusMessage ?? 'Failed to activate trial';
        setState(() {
          _statusMessage = 'Activation failed. Please try again.';
        });
        showCustomToast(errorMessage);
        widget.onActivationError?.call(errorMessage);
        
      default:
        if (wsResponse.statusMessage != null) {
          setState(() {
            _statusMessage = wsResponse.statusMessage!;
          });
        }
    }
  }

  void _startTimeoutTimer() {
    // Set a timeout for activation (e.g., 2 minutes)
    _timeoutTimer = Timer(const Duration(minutes: 2), () {
      if (mounted) {
        setState(() {
          _statusMessage = 'Activation is taking longer than expected...';
        });
        
        // Optionally call error callback after timeout
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            widget.onActivationError?.call('Activation timeout');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _webSocketService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FadingCircularProgress(
                    
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Activating your\nfree trial',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xff1f2024),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: Color(0xff71727a),
                      ),
                    ),
                  ),
                  
                  // Connection status indicator (only show if WebSocket is enabled)
                  if (widget.invoiceNumber != null) ...[
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isConnected ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _isConnected ? Colors.green : Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isConnected ? 'Connected' : 'Connecting...',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              color: _isConnected ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
