module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  
  class Ledger
    def record(expense)
      if expense.has_key?('payee')
        DB[:expenses].insert(expense)
        id = DB[:expenses].max(:id)
        RecordResult.new(true, id, nil)
      else
        RecordResult.new(false, nil, '`payee` is required')
      end
    end
    
    def expenses_on(date)
    end
  end
end
