require File.expand_path '../spec_helper.rb', __FILE__
require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do
  let(:lead) do
    lead = OpenStruct.new
    lead.source = source
    lead.product = product

    lead
  end

  let(:source) do
    source = OpenStruct.new
    source.name = source_name

    source
  end

  let(:product) do
    product = OpenStruct.new
    product.name = product_name

    product
  end

  context 'when product name contains "jumpy"' do
    let(:source_name) { 'Webmotors - Novos' }
    let(:product_name) { 'Citroën Jumpy' }

    it 'returns source name' do
      expect(described_class.switch_source(lead)).to eq('Webmotors - Novos - Citroën Jumpy')
    end
  end

  context 'when product name contains "expert"' do
    let(:source_name) { 'Webmotors - Novos' }
    let(:product_name) { 'Peugeot Expert' }

    it 'returns source name' do
      expect(described_class.switch_source(lead)).to eq('Webmotors - Novos - Peugeot Expert')
    end
  end

  context 'when product name contains "partner"' do
    let(:source_name) { 'Webmotors - Pendentes' }
    let(:product_name) { 'Peugeot Partner CMD6447' }

    it 'returns source name' do
      expect(described_class.switch_source(lead)).to eq('Webmotors - Pendentes - Peugeot Partner')
    end
  end

  context 'when product name is nil' do
    let(:source_name) { 'Webmotors - Novos' }
    let(:product_name) { nil }

    it 'returns source name' do
      expect(described_class.switch_source(lead)).to eq('Webmotors - Novos')
    end
  end

  context 'when source name is Grow' do
    let(:source_name) { 'Grow - TORIBA GASTÃO VIDIGAL' }

    context 'when product name contains New E208 GT' do
      let(:product_name) { 'NEW E208 GT' }

      it 'return source name' do
        expect(described_class.switch_source(lead)).to eq('Grow - TORIBA GASTÃO VIDIGAL - E208GT')
      end
    end

    context 'when product name contains New E208 GT' do
      let(:product_name) { 'NEW E-208 GT 21/22' }

      it 'return source name' do
        expect(described_class.switch_source(lead)).to eq('Grow - TORIBA GASTÃO VIDIGAL - E208GT')
      end
    end

    context 'when product name contains New E208 GT' do
      let(:product_name) { 'NEW E-208 Gt' }

      it 'return source name' do
        expect(described_class.switch_source(lead)).to eq('Grow - TORIBA GASTÃO VIDIGAL - E208GT')
      end
    end

    context 'when product name contains Casa cor' do
      let(:product_name) { 'casa cor' }

      it 'return source name' do
        expect(described_class.switch_source(lead)).to eq('Grow - TORIBA GASTÃO VIDIGAL - E208GT')
      end
    end

    context 'when product name contains New E208 GT' do
      let(:product_name) { 'NEW E-208 Gt' }
      let(:source_name) { 'Webmotors - Novos' }

      it 'return source name' do
        expect(described_class.switch_source(lead)).to eq('Webmotors - Novos')
      end
    end

    context 'when product name contains New E208 GT' do
      let(:product_name) { nil }

      it 'return source name' do
        expect(described_class.switch_source(lead)).to eq('Grow - TORIBA GASTÃO VIDIGAL')
      end
    end
  end
end
