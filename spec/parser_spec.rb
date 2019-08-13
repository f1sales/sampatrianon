require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is to Lapa' do

    context 'when is about a citroen'  do
      let(:email) do
        email = OpenStruct.new
        email.to = [email: 'websitelapa@lojateste.f1sales.org']
        email.subject = 'Campanha - PCD C4 CACTUS'
        email.body = "Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nGastão Vidigal\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.citroentrianon.com.br/pcd/c4_cactus/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*"

        email
      end

      let(:parsed_email) { described_class.new(email).parse }

      it 'contains website novos as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[2][:name])
      end 

      it 'contains name' do
        expect(parsed_email[:customer][:name]).to eq('Joao')
      end

      it 'contains email' do
        expect(parsed_email[:customer][:email]).to eq('joao.marcos@criah.com.br')
      end

      it 'contains phone' do
        expect(parsed_email[:customer][:phone]).to eq('11111111111')
      end

    end

    context 'when is about a peugeout'  do

      let(:email) do
        email = OpenStruct.new
        email.to = [email: 'websitelapa@lojateste.f1sales.org']
        email.subject = 'Campanha - PCD C4 CACTUS'
        email.body = "Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nLapa\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.peugeottrianon.com.br/pcd/c4_cactus/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*"

        email
      end

      let(:parsed_email) { described_class.new(email).parse }

      it 'contains website novos as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[3][:name])
      end

      it 'contains name' do
        expect(parsed_email[:customer][:name]).to eq('Joao')
      end

      it 'contains email' do
        expect(parsed_email[:customer][:email]).to eq('joao.marcos@criah.com.br')
      end

      it 'contains phone' do
        expect(parsed_email[:customer][:phone]).to eq('11111111111')
      end
    end

  end

  context 'when is to Gastão Vidigal' do

    context 'when is about a peugeout'  do
      let(:email) do
        email = OpenStruct.new
        email.to = [email: 'websitegastao@lojateste.f1sales.org']
        email.subject = 'Campanha - PCD C4 CACTUS'
        email.body = "Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nGastão Vidigal\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.peugeottrianon.com.br/pcd/c4_cactus/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*"

        email
      end

      let(:parsed_email) { described_class.new(email).parse }

      it 'contains website novos as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
      end 

      it 'contains name' do
        expect(parsed_email[:customer][:name]).to eq('Joao')
      end

      it 'contains email' do
        expect(parsed_email[:customer][:email]).to eq('joao.marcos@criah.com.br')
      end

      it 'contains phone' do
        expect(parsed_email[:customer][:phone]).to eq('11111111111')
      end
    end

    context 'when is about a citroen'  do
      let(:email) do
        email = OpenStruct.new
        email.to = [email: 'websitegastao@lojateste.f1sales.org']
        email.subject = 'Campanha - PCD C4 CACTUS'
        email.body = "Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nGastão Vidigal\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.citroentrianon.com.br/pcd/c4_cactus/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*"

        email
      end

      let(:parsed_email) { described_class.new(email).parse }

      it 'contains website novos as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
      end 

      it 'contains name' do
        expect(parsed_email[:customer][:name]).to eq('Joao')
      end

      it 'contains email' do
        expect(parsed_email[:customer][:email]).to eq('joao.marcos@criah.com.br')
      end

      it 'contains phone' do
        expect(parsed_email[:customer][:phone]).to eq('11111111111')
      end
    end

  end  
end
