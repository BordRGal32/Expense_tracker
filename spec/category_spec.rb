require 'spec_helper'

describe "Category" do
  it 'initializes with a type, amount, and date in a hash' do
    category = Category.new({'type' => 'footwear'})
    category.should be_an_instance_of Category
  end

  it 'should give us the type' do
    category = Category.new({'type' => 'footwear'})
    category.type.should eq 'footwear'
  end

  describe '.all' do
    it 'should be empty at first' do
      Category.all.should eq []
    end
  end

  it 'should save the instance to the database' do
    category = Category.new({'type' => 'footwear'})
    category.save
    Category.all.should eq [category]
  end

  it 'should give us the instance id' do
    category = Category.new({'type' => 'footwear'})
    category.save
    category.id.should be_an_instance_of Fixnum
  end

  it 'should be the same if it has the same name' do
    category1 = Category.new({'type' => 'footwear'})
    category2 = Category.new({'type' => 'footwear'})
    category1.should eq category2
  end

  describe 'delete' do
    it 'deletes an instance from the database' do
      category1 = Category.new({'type' => 'footwear'})
      category1.delete
      Category.all.should eq []
    end
  end

  describe "add_combo" do
    it "creates a new entry in expense_categories matching an expense and a category" do
      test_expense = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "02-02-2004", 'company_id' => 1})
      test_category = Category.new({'type' => 'footwear'})
      result = test_category.add_combo(test_expense.id)
      result.first.should_not eq nil
    end
  end

  describe 'total_category_expense' do
    it 'returns the total spend in this category' do
      test_category = Category.new({'type' => 'footwear'})
      test_expense = Expense.new({'description' => 'nike shoes', 'amount' => 99, 'date' => "02-02-2004", 'company_id' => 1})
      test_category.save
      test_expense.save
      test_category.add_combo(test_expense.id)
      test_category.total_category_expense.should eq 99
    end
  end

  describe 'percent_spent' do
    it 'returns the percentage of total expense spent on this category to two significant figures' do
      test_category = Category.new({'type' => 'llama accessories'})
      test_category.save
      test_category2 = Category.new({'type' => 'electronics'})
      test_category2.save
      test_expense = Expense.new({'description' => 'Llama saddle', 'amount' => 45.00, 'date' => "02-02-2004", 'company_id' => 1})
      test_expense.save
      test_expense2 = Expense.new({'description' => 'iPhone', 'amount' => 500.00, 'date' => "02-02-2014", 'company_id' => 1})
      test_expense2.save
      test_category.add_combo(test_expense.id)
      test_category2.add_combo(test_expense2.id)
      test_category.percent_spent.should eq 8.0
    end
    it 'works when an expense has multiple categories' do
      test_category = Category.new({'type' => 'llama accessories'})
      test_category.save
      test_category2 = Category.new({'type' => 'electronics'})
      test_category2.save
      test_expense = Expense.new({'description' => 'Llama saddle', 'amount' => 45.00, 'date' => "02-02-2004", 'company_id' => 1})
      test_expense.save
      test_expense2 = Expense.new({'description' => 'iPhone', 'amount' => 500.00, 'date' => "02-02-2014", 'company_id' => 1})
      test_expense2.save
      test_expense3 = Expense.new({'description' => 'llama monitor', 'amount' => 100.00, 'date' => "02-02-2004", 'company_id' => 1})
      test_expense3.save
      test_category.add_combo(test_expense.id)
      test_category2.add_combo(test_expense2.id)
      test_category2.add_combo(test_expense3.id)
      test_category.add_combo(test_expense3.id)
      test_category.percent_spent.should eq 22.0
      test_category2.percent_spent.should eq 93.0
    end
  end
end
