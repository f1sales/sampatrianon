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
        if product_name_down.include?('new e') || product_name_down.include?('casa por')
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
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website - Lapa - Citroen'
        },
        {
          email_id: 'website',
          name: 'Website - Lapa - Pegeout'
        },
        {
          email_id: 'website',
          name: 'Website - Lapa - PCD'
        },
        {
          email_id: 'website',
          name: 'Website - Lapa - Utilitários'
        },
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Telefone|Origem|Nome|Site|E-mail|Mensagem|Link da Land).*?:/, false)

      all_sources = F1SalesCustom::Email::Source.all
      # destinatary = @email.to.map { |email| email[:email].split('@').first }

      source = all_sources[0]
      source = all_sources[1] if (parsed_email['link_da_land'] || parsed_email['origem'] || '').downcase.include?('peugeot')
      source = all_sources[1] if (parsed_email['site'] || '').downcase.include?('peugeot')
      source = all_sources[2] if @email.subject.downcase.include?('pcd')
      source = all_sources[3] if (parsed_email['link_da_land'] || parsed_email['origem'] || '').downcase.include?('utilitarios')

      {
        source: {
          name: source[:name]
        },
        customer: {
          name: parsed_email['nome'],
          phone: (parsed_email['telefone'] || '').tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: { name: (parsed_email['interesse'] || '') },
        message: (parsed_email['menssage'] || parsed_email['mensagem']).gsub('-', ' ').gsub("\n", ' ').strip,
        description: parsed_email['assunto']
      }
    end
  end
end
