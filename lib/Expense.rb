require 'pg'
require 'pry'

class Expense
  attr_reader :description, :amount, :date, :id, :company_id
  def initialize expense_info
    @description = expense_info['description']
    @amount = expense_info['amount'].to_f
    @date = expense_info['date']
    @id = expense_info['id'].to_i
    @company_id = expense_info['company_id']
  end

  def self.all
    results = DB.exec("SELECT * FROM expenses")
    expenses = []
    results.each do |result|
      expenses << Expense.new(result)
    end
    expenses
  end

  def save
    result = DB.exec("INSERT INTO expenses (description, amount, date, company_id) VALUES ('#{@description}', #{@amount}, '#{@date}', '#{@company_id}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def ==(another)
    self.description == another.description && self.amount == another.amount && self.date == another.date && self.id == another.id
  end

  def set_description(new_description)
    @description = new_description
  end

  def set_amount(new_amount)
    @amount = new_amount
  end

  def set_date(new_date)
    @date = new_date
  end

  def set_company_id(new_company_id)
    @company_id = new_company_id
  end

  def update(attributes)
    attributes.each do |key, value|
      self.send "set_#{key.to_s}", value
    end
  end

  def delete
    DB.exec("DELETE FROM expenses WHERE id = @id;")
  end

  def self.total
    sum = DB.exec("SELECT sum(amount) FROM expenses;")
    sum.first['sum'].to_f
  end
end
