import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';

enum StkCallbackStatus {
  initial,
  cancelled,
  success,
  timeout,
  insufficient,
  wrongpin,
}

class WsResponse {
  final String? status;
  final String? statusMessage;
  final String? invoiceNumber;
  final String? amount;
  final String? transactionId;

  WsResponse({
    this.status,
    this.statusMessage,
    this.invoiceNumber,
    this.amount,
    this.transactionId,
  });

  factory WsResponse.fromJson(Map<String, dynamic> json) {
    return WsResponse(
      status: json['status']?.toString(),
      statusMessage: json['statusMessage']?.toString(),
      invoiceNumber: json['invoiceNumber']?.toString(),
      amount: json['amount']?.toString(),
      transactionId: json['transactionId']?.toString(),
    );
  }
}

class WebSocketService {
  WebSocketChannel? _channel;
  StreamController<WsResponse>? _messageController;
  StreamController<bool>? _connectionController;
  Timer? _heartbeatTimer;
  bool _isConnected = false;

  Stream<WsResponse> get messageStream => _messageController!.stream;
  Stream<bool> get connectionStream => _connectionController!.stream;
  bool get isConnected => _isConnected;

  WebSocketService() {
    _messageController = StreamController<WsResponse>.broadcast();
    _connectionController = StreamController<bool>.broadcast();
  }

  Future<void> connect(String invoiceNumber, {String? userToken}) async {
    try {
      if (userToken == null) {
        throw Exception('Token must be provided');
      }
      final token = userToken;
      final websocketUrl = 'wss://${AppConstants.domainName}/notification/$invoiceNumber';

      logger.d('Connecting to WebSocket: $websocketUrl');

      final uri = Uri.parse(websocketUrl);
      _channel = WebSocketChannel.connect(
        uri,
        protocols: null,
      );

      // Send authentication token as first message
      _channel!.sink.add(jsonEncode({'token': token}));

      _isConnected = true;
      _connectionController!.add(true);

      // Listen to messages
      _channel!.stream.listen(
            (message) {
          _handleMessage(message);
        },
        onError: (error) {
          logger.e('WebSocket error: $error');
          _handleDisconnection();
        },
        onDone: () {
          logger.d('WebSocket connection closed');
          _handleDisconnection();
        },
      );

      // Start heartbeat
      _startHeartbeat();

      logger.d('WebSocket connected successfully');
    } catch (e) {
      logger.e('Failed to connect to WebSocket: $e');
      _handleDisconnection();
    }
  }

  void _handleMessage(dynamic message) {
    try {
      logger.d('WebSocket message received: $message');

      if (message is String) {
        // Try to parse as JSON
        try {
          final jsonData = jsonDecode(message);
          final wsResponse = WsResponse.fromJson(jsonData as Map<String, dynamic>);
          _messageController!.add(wsResponse);
        } catch (e) {
          // If not JSON, treat as plain text status message
          final wsResponse = WsResponse(
            status: message.toLowerCase(),
            statusMessage: message,
          );
          _messageController!.add(wsResponse);
        }
      }
    } catch (e) {
      logger.e('Error handling WebSocket message: $e');
    }
  }

  void _handleDisconnection() {
    _isConnected = false;
    _connectionController!.add(false);
    _heartbeatTimer?.cancel();
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected && _channel != null) {
        try {
          _channel!.sink.add('ping');
        } catch (e) {
          logger.e('Heartbeat failed: $e');
          _handleDisconnection();
        }
      }
    });
  }

  void sendMessage(String message) {
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(message);
      } catch (e) {
        logger.e('Failed to send message: $e');
      }
    }
  }

  void disconnect() {
    try {
      _heartbeatTimer?.cancel();
      _channel?.sink.close(status.goingAway);
      _isConnected = false;
      _connectionController!.add(false);
      logger.d('WebSocket disconnected');
    } catch (e) {
      logger.e('Error disconnecting WebSocket: $e');
    }
  }

  void dispose() {
    disconnect();
    _messageController?.close();
    _connectionController?.close();
  }
}
