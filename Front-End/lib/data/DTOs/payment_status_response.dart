class PaymentStatusResponse {
  final bool success;
  final String? message;
  final String? paymentStatus;
  final int? paymentStatusCode;

  PaymentStatusResponse({
    required this.success,
    this.message,
    this.paymentStatus,
    this.paymentStatusCode,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json['success'] ?? false,
      message: json['message'],
      paymentStatus: json['paymentStatus'],
      paymentStatusCode: json['paymentStatusCode'],
    );
  }
}