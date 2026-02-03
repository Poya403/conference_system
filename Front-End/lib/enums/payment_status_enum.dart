enum PaymentStatusEnum {
  inBasket,    // 0
  registered,  // 1
  inWaiting,   // 2
  cancelled,   // 3
}

PaymentStatusEnum paymentStatusFromInt(int value) {
  return PaymentStatusEnum.values[value];
}

int paymentStatusToInt(PaymentStatusEnum status) {
  return status.index;
}
