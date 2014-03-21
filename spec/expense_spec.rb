require 'spec_helper'

describe Expense do
  it 'initializes with a description, amount, and date in a hash' do
    expense = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "02-02-2004", 'company_id' => 1})
    expense.should be_an_instance_of Expense
  end

  it 'should give us the description, amount, and date' do
    expense = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "02-02-2004", 'company_id' => 1})
    expense.description.should eq 'nike shoes'
    expense.amount.should eq 99
    expense.date.should eq "02-02-2004"
  end

  describe '.all' do
    it 'should be empty at first' do
      expense = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "02-02-2004", 'company_id' => 1})
      Expense.all.should eq []
    end
  end

  it 'should save the instance to the database' do
    expense = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "2004-02-02", 'company_id' => 1})
    expense.save
    Expense.all.should eq [expense]
  end

  it 'should give us the instance id' do
    expense = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "2000/02/02", 'company_id' => 1})
    expense.save
    expense.id.should be_an_instance_of Fixnum
  end

  it 'should be the same if it has the same name' do
    expense1 = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "02-02-2004", 'company_id' => 1})
    expense2 = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "02-02-2004", 'company_id' => 1})
    expense1.should eq expense2
  end

  describe 'delete' do
    it 'deletes an instance from the database' do
      expense1 = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "02-02-2004", 'company_id' => 1})
      expense1.delete
      Expense.all.should eq []
    end
  end

  describe '.total' do
    it 'returns the total of all expenses' do
      expense1 = Expense.new({'description' => 'Llama Saddle', 'amount' => 45.00, 'date' => "02-02-2004", 'company_id' => 1})
      expense1.save
      expense2 = Expense.new({'description' => 'Llama food', 'amount' => 456.84, 'date' => "02-03-2005", 'company_id' => 1})
      expense2.save
      Expense.total.should eq 501.84
    end
  end
end
