require 'rspec'
require 'pg'
require 'Expense'
require 'Company'
require 'Category'
require 'pry'


DB = PG.connect({:dbname => 'expense_organizer_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM expenses *;")
    DB.exec("DELETE FROM category *;")
    DB.exec("DELETE FROM company *;")
    DB.exec("DELETE FROM expense_categories *;")
  end
end
