class GatewayToken < EstablishOstPaymentClientDbConnection

  enum gateway_type: GlobalConstant::GatewayType.gateway_types_enum

end
