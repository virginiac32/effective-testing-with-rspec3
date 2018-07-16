require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods
    def app
      API.new(ledger: ledger)
    end

    def response_body
      JSON.parse(last_response.body)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    let(:expense) { { 'some' => 'data' } }

    describe 'POST /expenses' do
      context 'when the input format is JSON' do
        before do
          # header('Content-Type', 'text/json')
        end

        context 'when the expense is successfully recorded' do
          before do
            allow(ledger).to receive(:record)
              .with(expense)
              .and_return(RecordResult.new(true, 417, nil))
          end

          it 'returns the expense id' do
            post '/expenses', JSON.generate(expense)

            expect(response_body).to include('expense_id' => 417)
          end

          it 'responds with a 200 (OK)' do
            post '/expenses', JSON.generate(expense)
            expect(last_response.status).to eq(200)
          end
        end

        context 'when the expense fails validation' do
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, "Expense incomplete"))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          expect(response_body).to include("error" => "Expense incomplete")
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
        end
      end

      context 'when the input format is XML' do
        context 'when the expense is successfully recorded'
        context 'when the expense fails validation'
      end

      context 'when the input format is unsupported' do

      end

      context 'when the input format does not match the advertised format' do

      end
    end

    describe 'GET /expenses/:date' do
      before do
        # header('Content-Type', 'text/json')
      end

      context 'when the expenses exist on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2018-01-01')
            .and_return(['expense_1', 'expense_2'])
        end

        it 'returns the expense' do
          get '/expenses/2018-01-01'

          expect(response_body).to eq(['expense_1', 'expense_2'])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2018-01-01'

          expect(last_response.status).to eq(200)
        end
      end

      context 'when no expenses exist on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2018-01-02')
            .and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2018-01-02'

          expect(response_body).to eq([])
        end
        it 'responds with a 200 (OK)' do
          get '/expenses/2018-01-02'

          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
