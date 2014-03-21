require 'spec_helper'

describe "Company" do
  describe "total_company_expense" do
    it "displays the total amount spent on a company" do
      test_company = Company.new({:name => 'Nike'})
      test_company.save
      test_expense = Expense.new({'description' => 'shoes', 'amount' => 99.00, 'date' => "02-02-2004", 'company_id' => test_company.id})
      test_expense.save
      test_company.total_company_expense.should eq 99.00
    end
  end

  describe 'company_percent_spent' do
    it 'displays the percentange of total spending make up by this company' do
      test_company = Company.new({:name => 'Nike'})
      test_company.save
      test_expense = Expense.new({'description' => 'shoes', 'amount' => 99.00, 'date' => "02-02-2004", 'company_id' => test_company.id})
      test_expense1 = Expense.new({'description' => 'shoes', 'amount' => 50.00, 'date' => "02-02-2004", 'company_id' => test_company.id + 1})
      test_expense.save
      test_expense1.save
      test_company.company_percent_spent.should eq 66.00
    end
  end
end
