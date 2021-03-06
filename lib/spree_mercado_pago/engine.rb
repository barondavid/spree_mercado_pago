require 'spree_core'

module SpreeMercadoPago
  class Engine < Rails::Engine

    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_mercado_pago'

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../../app/overrides/*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree_payment_network.register.payment_methods" do |app|
      app.config.spree.payment_methods += [Spree::MercadoPago::Gateways::CreditCard, Spree::MercadoPago::Gateways::Ticket]
      app.config.assets.precompile += %w( spree/payments/mercado_pago_credit_card.js spree/payments/mercado_pago_ticket.js )
    end

    Spree::PermittedAttributes.source_attributes.push :token, :installments, :collected_amount, :transaction_type, :card_name, :doc_type, :doc_number, :last_four, :payment_option
  end
end
