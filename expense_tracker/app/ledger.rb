require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  
  class Ledger
    def record(expense)
      if expense.has_key?('payee')
        DB[:expenses].insert(expense)
        id = DB[:expenses].max(:id)
        RecordResult.new(true, id, nil)
      else
        RecordResult.new(false, nil, 'Invalid expense: `payee` is required')
      end
    end
    
    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end
  end
end
