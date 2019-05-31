class GatewayCustomerAssociation < EstablishOstPaymentClientDbConnection

  enum gateway_type: GlobalConstant::GatewayType.gateway_types_enum

  include AttributeParserConcern


end
