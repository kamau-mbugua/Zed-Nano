import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/networking/models/response_model.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/fading_circular_progress.dart';
import 'package:zed_nano/services/websocket_service.dart';
import 'package:zed_nano/utils/Common.dart';

typedef PaymentCallback = void Function();
typedef PaymentErrorCallback = void Function(String errorMessage);

enum STKPaymentType {
  Mpesa,
  KCB,
}

class MpesaPaymentWaitingScreen extends StatefulWidget {

  const MpesaPaymentWaitingScreen({
    required this.invoiceNumber, required this.referenceNumber, required this.paymentData, required this.sTKPaymentType, super.key,
    this.onPaymentSuccess,
    this.onPaymentError,
    this.onCancel,
  });
  final String invoiceNumber;
  final String referenceNumber;
  final Map<String, dynamic> paymentData;
  final PaymentCallback? onPaymentSuccess;
  final PaymentErrorCallback? onPaymentError;
  final VoidCallback? onCancel;
  final STKPaymentType? sTKPaymentType;

  @override
  State<MpesaPaymentWaitingScreen> createState() =>
      _MpesaPaymentWaitingScreenState();
}

class _MpesaPaymentWaitingScreenState extends State<MpesaPaymentWaitingScreen> {
  WebSocketService? _webSocketService;
  Timer? _countdownTimer;
  int _resendCountdown = 60;
  bool _canResend = false;
  bool _isLoading = false;
  String _userToken = '';

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    _startResendCountdown();
    _userToken = getAuthProvider(context).token;
  }

  void _initializeWebSocket() {
    _webSocketService = WebSocketService();

    // Listen to connection status
    _webSocketService!.connectionStream.listen((isConnected) {
      logger.d('WebSocket connection status: $isConnected');
      if (!isConnected && mounted) {
        // Handle disconnection if needed
      }
    });

    // Listen to messages
    _webSocketService!.messageStream.listen(_handleWebSocketMessage);

    // Connect to WebSocket
    _webSocketService!.connect(widget.referenceNumber, userToken: _userToken);
  }

  void _handleWebSocketMessage(WsResponse wsResponse) {
    if (!mounted) return;

    logger.d(
        'WebSocket message: ${wsResponse.status} - ${wsResponse.statusMessage}',);

    switch (wsResponse.status?.toLowerCase()) {
      case 'initial':
        // Initial state, do nothing
        break;

      case 'cancelled':
        _handlePaymentResult(
          isSuccess: false,
          message: wsResponse.statusMessage ?? 'Payment was cancelled',
        );

      case 'success':
        _handlePaymentResult(
          isSuccess: true,
          message: 'Payment completed successfully!',
        );

      case 'timeout':
        _handlePaymentResult(
          isSuccess: false,
          message: wsResponse.statusMessage ?? 'Payment timed out',
        );

      case 'insufficient':
        _handlePaymentResult(
          isSuccess: false,
          message: wsResponse.statusMessage ?? 'Insufficient funds',
        );

      case 'wrongpin':
        _handlePaymentResult(
          isSuccess: false,
          message: wsResponse.statusMessage ?? 'Wrong PIN entered',
        );

      case 'failed':
        // Stop WebSocket but keep screen open for specific error messages
        _webSocketService?.close();

        if (wsResponse.statusMessage?.toLowerCase() ==
            'no response from user') {
          // Don't close screen, just show resend button
          setState(() {
            _canResend = true;
            _resendCountdown = 0; // Reset countdown
          });
          showCustomToast('No response from user. You can try again.',);
        } else {
          // For other failed cases, close the screen
          _handlePaymentResult(
            isSuccess: false,
            message: wsResponse.statusMessage ??
                'Payment failed: Invalid initiator information',
          );
        }
      default:
        logger.d('Unknown payment status: ${wsResponse.status}');
    }
  }

  void _handlePaymentResult(
      {required bool isSuccess, required String message,}) {
    if (!mounted) return;

    if (isSuccess) {
      showCustomToast(message, isError: false);
      widget.onPaymentSuccess?.call();
      // Don't auto-pop for success case since the callback handles navigation
      return;
    } else {
      showCustomToast(message);
      widget.onPaymentError?.call(message);
    }

    // Close the screen after a short delay (only for error cases)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _startResendCountdown() {
    _canResend = false;
    _resendCountdown = 60;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendSTKPush() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final ResponseModel response;
      if (widget.sTKPaymentType == STKPaymentType.KCB) {
        response = await getBusinessProvider(context).doInitiateKcbStkPush(
          requestData: widget.paymentData,
          context: context,
        );
      }else{
        response = await getBusinessProvider(context).doPushStk(
          requestData: widget.paymentData,
          context: context,
        );
      }


      if (response.isSuccess) {
        showCustomToast('You will receive a prompt on your phone',
            isError: false,);
        _startResendCountdown();
      } else {
        showCustomToast(response.message ?? 'Failed to send payment prompt',);
      }
    } catch (e) {
      showCustomToast('Failed to resend payment prompt');
      logger.e('Error resending STK push: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _webSocketService?.dispose();
    super.dispose();
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
            widget.onCancel?.call();
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Payment Processing',
          style: TextStyle(
            color: Color(0xff1f2024),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Loader
              const FadingCircularProgress(
                width: 120,
                height: 120,
                strokeWidth: 8,
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                'Processing Payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xff1f2024),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                'Please complete the payment on your phone.\nYou should receive an M-Pesa prompt shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  color: Color(0xff71727a),
                ),
              ),
              const SizedBox(height: 20),
              // Resend Button or Countdown
              if (_canResend)
                appButton(
                    text: 'Resend Payment Prompt',
                    onTap: () async {
                      if (_isLoading) return;

                      // Close existing WebSocket connection
                      _webSocketService?.close();

                      // Reset state
                      setState(() {
                        _canResend = false;
                        _resendCountdown = 60;
                      });

                      // Reinitialize WebSocket
                      _initializeWebSocket();

                      // Resend STK push
                      await _resendSTKPush();
                    },
                    context: context,)
              else
                Text(
                  'Resend Prompt: $_resendCountdown seconds',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Color(0xff71727a),
                  ),
                ),

              const SizedBox(height: 24),

              outlineButton(
                  text: 'Cancel Payment',
                  onTap: () {
                    // Stop WebSocket but keep screen open
                    setState(() {
                      _canResend = true;
                      _resendCountdown = 0; // Reset countdown
                    });
                    _webSocketService?.close();
                    widget.onCancel?.call();
                  },
                  context: context,),
            ],
          ),
        ),
      ),
    );
  }
}
