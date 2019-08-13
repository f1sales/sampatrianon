require "sampatrianon/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"

module Sampatrianon
  class Error < StandardError; end
  class F1SalesCustom::Email::Source 
    def self.all
      [
        {
          email_id: 'websitegastao',
          name: 'Website - Gastão - Citroen'
        },
        {
          email_id: 'websitegastao',
          name: 'Website - Gastão - Pegeout'
        },
        {
          email_id: 'websitelapa',
          name: 'Website - Lapa - Citroen'
        },
        {
          email_id: 'websitelapa',
          name: 'Website - Lapa - Pegeout'
        },
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash
      all_sources = F1SalesCustom::Email::Source.all
      destinatary = @email.to.map { |email| email[:email].split('@').first } 
      source = all_sources[0] 

      if destinatary.include?('websitegastao')
        source = all_sources[1] if parsed_email['link_da_land'].downcase.include?('peugeot')
      elsif  destinatary.include?('websitelapa')
        source = all_sources[2] 
        source = all_sources[3] if parsed_email['link_da_land'].downcase.include?('peugeot')
      end

      {
        source: {
          name: source[:name],
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: (parsed_email['interesse'] || ''),
        message: (parsed_email['menssage'] || parsed_email['mensagem']).gsub('-', ' ').gsub("\n", ' ').strip,
        description: parsed_email['assunto'],
      }
    end
  end
end
