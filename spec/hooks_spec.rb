require File.expand_path '../spec_helper.rb', __FILE__
require 'ostruct'
require "f1sales_custom/hooks"

RSpec.describe F1SalesCustom::Hooks::Lead do

  context 'when is peugeot' do
    context 'when is to lapa' do
      let(:source) do
        source = OpenStruct.new
        source.name = 'Facebook - Peugeot Trianon'
        source
      end

      let(:lead) do
        lead = OpenStruct.new
        lead.message = 'loja: Lapa: contato: 1198899888'
        lead.source = source

        lead
      end

      it 'sets Lapa store source' do
        expect(described_class.switch_source(lead)).to eq(source.name + described_class.source[:facebook_lapa])
      end

    end
  end

  context 'when is citroen' do

    context 'when is to gastão' do
      let(:source) do
        source = OpenStruct.new
        source.name = 'Facebook - Trianon Citroen'
        source
      end

      let(:customer) do
        customer = OpenStruct.new
        customer.name = 'Marcio'
        customer.phone = '1198788899'
        customer.email = 'marcio@f1sales.com.br'

        customer
      end

      let(:product) do
        product = OpenStruct.new
        product.name = 'Some product'

        product
      end

      let(:lead) do
        lead = OpenStruct.new
        lead.message = 'loja: gastão_vidigal: contato: 1198899888'
        lead.source = source
        lead.product = product
        lead.customer = customer

        lead
      end

      let(:call_url){ "https://trianongastao.f1sales.org/leads" }

      let(:lead_payload) do
        {
          lead: {
            message: lead.message,
            customer: {
              name: customer.name,
              phone: customer.phone,
              email: customer.email,
            },
            product: {
              name: product.name
            },
            source: {
              name: source.name
            }
          }
        }
      end

      before do
        stub_request(:post, call_url).
          with(body: lead_payload,
               headers: {
            'Accept'=>'application/json',
            'Content-Type'=>'application/x-www-form-urlencoded'
          }).to_return(status: 200, body: "", headers: {})

        described_class.switch_source(lead)
      end

      it 'returns nil' do
        expect(described_class.switch_source(lead)).to be_nil
      end

      it 'post to gastao vidigal' do
        expect(WebMock).to have_requested(:post, call_url).
          with(body: lead_payload)
      end

    end

    context 'when is to lapa' do
      let(:source) do
        source = OpenStruct.new
        source.name = 'Facebook - Trianon Citroen'
        source
      end

      let(:lead) do
        lead = OpenStruct.new
        lead.message = 'loja: Lapa: contato: 1198899888'
        lead.source = source

        lead
      end

      it 'sets Lapa store source' do
        expect(described_class.switch_source(lead)).to eq(source.name + described_class.source[:facebook_lapa])
      end

    end
  end
end
