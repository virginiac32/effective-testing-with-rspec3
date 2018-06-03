require_relative '../../../app/ledger'
require_relative '../../../config/sequel'

module ExpenseTracker
  RSpec.describe Ledger, :aggregate_failures, :db do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10',
      }
    end

    describe '#record' do
      it 'successfully saves the expense in the database' do
        result = ledger.record(expense)
        
        expect(result).to be_success
        expect(DB[:expenses].all).to match [a_hash_including(
          id: result.expense_id,
          payee: 'Starbucks',
          amount: 5.75,
          date: Date.parse('2017-06-10')
        )]
      end

      context 'when the expense lacks a payee' do
        let(:expense) do
          {
            'amount' => 5.75,
            'date' => '2017-06-10',
          }
        end

        it 'rejects the expense as invalid' do
          result = ledger.record(expense)
          expect(result).not_to be_success
          expect(result.expense_id).to eq nil

          expect(result.error_message).to eq('`payee` is required')
          expect(DB[:expenses].count).to eq 0
        end
      end
    end

    describe '#expenses_on' do
      it 'returns all expenses for the provided date' do
        expense1 = { 'payee' => 'Starbucks', 'amount' => 5.75, 'date' => '2017-06-10' }
        expense2 = { 'payee' => 'Gym', 'amount' => 10.00, 'date' => '2017-06-10' }
        expense3 = { 'payee' => 'Nordstrom', 'amount' => 100.00, 'date' => '2017-06-10' }
        ledger.record(expense1)
        ledger.record(expense2)
        ledger.record(expense3)

        expenses = ledger.expenses_on('2017-06-10')
        # expect(expenses).to eq()
      end
      it 'returns a blank array when there are no matching expenses' do

      end
    end
  end
end
