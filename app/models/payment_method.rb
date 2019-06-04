class PaymentMethod < EstablishOstPaymentClientDbConnection

  serialize :details, Hash

  enum gateway_type: GlobalConstant::GatewayType.gateway_types_enum

  enum payment_method: {
      GlobalConstant::PaymentMethod.card_payment_method => 1,
      GlobalConstant::PaymentMethod.paypal_payment_method => 2
  }

end
