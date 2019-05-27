class EstablishOstPaymentClientDbConnection < ApplicationRecord
  self.abstract_class = true

  def self.config_key
    "ost_payment_client_#{Rails.env}"
  end

  self.establish_connection(config_key.to_sym)
end
