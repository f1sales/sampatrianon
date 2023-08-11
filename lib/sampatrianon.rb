require 'sampatrianon/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'
require 'f1sales_helpers'
require 'http'

module Sampatrianon
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    def self.switch_source(lead)
      product_name = lead.product&.name || ''
      product_name_down = product_name.downcase
      source_name = lead.source&.name || ''

      if product_name_down.include?('jumpy')
        "#{source_name} - Citroën Jumpy"
      elsif product_name_down.include?('expert')
        "#{source_name} - Peugeot Expert"
      elsif product_name_down.include?('partner')
        "#{source_name} - Peugeot Partner"
      elsif source_name.downcase.include?('grow')
        if product_name_down.include?('new e') || product_name_down.include?('casa cor')
          "#{source_name} - E208GT"
        else
          source_name
        end
      else
        source_name
      end
    end
  end

  class F1SalesCustom::Email::Source
    class << self
      def all
        [
          citroen,
          peugeot,
          pcd,
          utilitarios
        ]
      end

      private

      def citroen
        {
          email_id: 'website',
          name: 'Website - Lapa - Citroen'
        }
      end

      def peugeot
        {
          email_id: 'website',
          name: 'Website - Lapa - Pegeout'
        }
      end

      def pcd
        {
          email_id: 'website',
          name: 'Website - Lapa - PCD'
        }
      end

      def utilitarios
        {
          email_id: 'website',
          name: 'Website - Lapa - Utilitários'
        }
      end
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      @source = all_sources[0]
      @source = all_sources[1] if choose_campaign('peugeot')
      @source = all_sources[2] if @email.subject.downcase.include?('pcd')
      @source = all_sources[3] if choose_campaign('utilitarios')

      package_lead
    end

    private

    def all_sources
      F1SalesCustom::Email::Source.all
    end

    def parsed_email
      @email.body.colons_to_hash(/(#{string_to_regex}).*?:/, false)
    end

    def string_to_regex
      'Telefone|Celular|Origem|Nome|Site|E-mail|Email|Mensagem|Loja|Date|Link da Land|utm_source'
    end

    def choose_campaign(info)
      dealership_campaigns.any? { |campaign| (campaign || '').downcase[info] }
    end

    def dealership_campaigns
      [
        parsed_email['link_da_land'],
        parsed_email['origem'],
        parsed_email['site'],
        parsed_email['utmsource']
      ]
    end

    def package_lead
      {
        source: source_name,
        customer: customer,
        product: product,
        message: message,
        description: description
      }
    end

    def source_name
      {
        name: @source[:name]
      }
    end

    def customer
      {
        name: parsed_email['nome'],
        phone: (parsed_email['telefone'] || parsed_email['celular'] || '').tr('^0-9', ''),
        email: parsed_email['email']
      }
    end

    def product
      { name: (parsed_email['interesse'] || '') }
    end

    def message
      (parsed_email['menssage'] || parsed_email['mensagem'] || '').gsub('-', ' ').gsub("\n", ' ').strip
    end

    def description
      parsed_email['assunto']
    end
  end
end
