/// Response model for WhatsApp message generation for invoice
class GetWhatsappMessageForInvoiceResponse {

  GetWhatsappMessageForInvoiceResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetWhatsappMessageForInvoiceResponse.fromJson(Map<String, dynamic> json) {
    return GetWhatsappMessageForInvoiceResponse(
      status: json['Status'] as String?,
      message: json['message'] as String?,
      data: json['data'] as String?,
    );
  }
  final String? status;
  final String? message;
  final String? data;

  Map<String, dynamic> toJson() => {
    'Status': status,
    'message': message,
    'data': data,
  };

  /// Extracts the phone number from the WhatsApp URL
  String? get phoneNumber {
    if (data == null) return null;
    try {
      final uri = Uri.parse(data!);
      if (uri.host == 'wa.me') {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Extracts the message text from the WhatsApp URL
  String? get messageText {
    if (data == null) return null;
    try {
      final uri = Uri.parse(data!);
      return uri.queryParameters['text'];
    } catch (e) {
      return null;
    }
  }

  /// Checks if the response contains a valid WhatsApp URL
  bool get isValidWhatsappUrl {
    if (data == null) return false;
    try {
      final uri = Uri.parse(data!);
      return uri.host == 'wa.me' && uri.pathSegments.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Returns a user-friendly message for sharing
  String get shareableMessage {
    return messageText?.replaceAll('%2C', ',')
        .replaceAll('%20', ' ')
        .replaceAll('%22', '"')
        .replaceAll('%2F', '/')
        .replaceAll('%3A', ':')
        .replaceAll('%3F', '?')
        .replaceAll('%26', '&')
        .replaceAll('%3D', '=') ?? 
        'Invoice message from your business';
  }
}
