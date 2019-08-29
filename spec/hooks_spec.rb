require 'ostruct'
require "f1sales_custom/hooks"

RSpec.describe F1SalesCustom::Hooks::Lead do

  context 'when is citroen' do

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
