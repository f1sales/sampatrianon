require 'ostruct'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'byebug'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is to Lapa' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'websitelapa@lojateste.f1sales.org']
      email.subject = 'Campanha - C4 CACTUS'
      email.body = <<~BODY
        Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nGastão Vidigal\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.citroentrianon.com.br/utilitarios/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*
      BODY

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    context 'when is about SUV' do
      before do
        email.subject = 'Campanha - C4 CACTUS'
        email.body = <<~BODY
          Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nGastão Vidigal\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.citroentrianon.com.br/utilitarios/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*
        BODY
      end

      it 'contains website pcd as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[3][:name])
      end
    end

    context 'when is about a pcd' do
      before do
        email.subject = 'Campanha - PCD C4 CACTUS'
        email.body = <<~BODY
          Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nGastão Vidigal\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.citroentrianon.com.br/pcd/c4_cactus/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*
        BODY
      end

      it 'contains website pcd as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[2][:name])
      end
    end

    context 'when is about a citroen' do
      before do
        email.subject = 'Campanha - C4 CACTUS'
        email.body = <<~BODY
          Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nGastão Vidigal\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.citroentrianon.com.br/pcd/c4_cactus/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*
        BODY
      end

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

    context 'when is about a peugeout' do
      context 'when is different format' do
        before do
          email.subject = 'Solicitação de cotação por marcioklepacz@gmail.com em /seminovos/carros/peugeot-207/1265588'
          email.body = <<~BODY
            Site: https://toribapeugeot.com.br/Origem: /carrosNome: marcus vinicius barbosaE-mail: marcuscarequinha@gmail.comTelefone: (11) 99241-1129Mensagem: PRECOS DA EXPERT MINIBUS E FURGAO E SUAS CONFIGURACOES OU FICHA TECNICA
          BODY
        end

        it 'contains website novos as source name' do
          expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
        end
      end

      context 'when it does not gave line breaks' do
        before do
          email.subject = 'Solicitação de cotação por marcioklepacz@gmail.com em /seminovos/carros/peugeot-207/1265588'
          email.body = <<~BODY
            Site: https://toribacitroen.com.br/Origem: /seminovos/carros/peugeot-207/1265588Nome: Marcio KlepaczE-mail: marcioklepacz@gmail.comTelefone: (11) 98158-7311Mensagem: Lead teste entrar em contato e descartar
          BODY
        end

        it 'contains website novos as source name' do
          expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
        end

        it 'contains name' do
          expect(parsed_email[:customer][:name]).to eq('Marcio Klepacz')
        end

        it 'contains email' do
          expect(parsed_email[:customer][:email]).to eq('marcioklepacz@gmail.com')
        end

        it 'contains phone' do
          expect(parsed_email[:customer][:phone]).to eq('11981587311')
        end
      end

      context 'when it conatians site' do
        before do
          email.subject = 'Solicitação de cotação por marcioklepacz@gmail.com em /seminovos/carros/peugeot-207/1265588'
          email.body = <<~BODY
            Site: https://toribapeugeot.com.br/Nome: Marcio KlepaczE-mail: marcioklepacz@gmail.comTelefone: (11) 98158-7311Mensagem: Lead teste entrar em contato e descartar
          BODY
        end

        it 'contains website novos as source name' do
          expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
        end
      end

      context 'when has line breaks' do
        before do
          email.subject = 'Campanha - C4 CACTUS'
          email.body = <<~BODY
            Contato via site\n\n*Nome:*\n\nJoao\n\n*E-mail:*\n\njoao.marcos@criah.com.br\n\n*Telefone:*\n\n(11) 1 1111-1111\n\n*Loja:*\n\nLapa\n\n*Mensagem:*\n\nTeste\n\n-----------------------------------------------------------------------\n\n*Link da Land:*\n\npromocao.peugeottrianon.com.br/pcd/c4_cactus/\n\n\n\n\n\n*Mensagem de e-mail confidencial.*
          BODY
        end

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

      context 'when is Formulario: Home' do
        before do
          email.subject = 'Novo Lead - Seu Peugeot Toriba Lapa'
          email.body = <<~BODY
            Formulario: Home\nutm_source: seupeugeot\nutm_medium: ads\nutm_id: red\nNome: Wagner\nCelular: (11) 94433-1234\nEmail: wagner@msn.com\n\nLoja: Toriba Lapa\n\n---\n\nDate: 3 de agosto de 2023\nTime: 10:18\nPage URL:\nhttps://seupeugeot.com.br/?utm_source=seupeugeot&utm_medium=ads&utm_campaign=facebook&utm_id=red&fbclid=PAAaa6C-BM4xYA7QkuNUBANk9TeFZSLs80-kju5VEbCJX9pMOtAVdIluoncKo_aem_AWrrw4rcZcVCfhxOHKI_Xmht-5-2Zu-Fd1xXuTHaVOh3qp6bhnmGyH-Qi95EujLNTf41fPrvylkP6cWH8w4t3fue\nUser Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 16_5_1 like Mac OS X)\nAppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/20F75 Instagram\n294.0.0.21.52 (iPhone14,2; iOS 16_5_1; pt_BR; pt; scale=3.00; 1170x2532;\n499525414)\nRemote IP: 2804:431:e7c1:314b:d117:385d:663f:89cb
          BODY
        end

        it 'contains website novos as source name' do
          expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
        end

        it 'contains name' do
          expect(parsed_email[:customer][:name]).to eq('Wagner')
        end

        it 'contains email' do
          expect(parsed_email[:customer][:email]).to eq('wagner@msn.com')
        end

        it 'contains phone' do
          expect(parsed_email[:customer][:phone]).to eq('11944331234')
        end
      end
    end
  end
end
