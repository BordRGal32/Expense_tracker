require 'pg'
require 'pry'

class Category
  attr_reader :type, :id

  def initialize(category_info)
    @type = category_info['type']
    @id = category_info['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM category")
    categories = []
    results.each do |result|
      categories << Category.new(result)
    end
    categories
  end

  def save
    result = DB.exec("INSERT INTO category (type) VALUES ('#{@type}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def ==(another)
    self.type == another.type && self.id == another.id
  end

  def set_type(new_type)
    @type = new_type
  end

  def update(attributes)
    attributes.each do |key, value|
      self.send "set_#{key.to_s}", value
    end
  end

  def delete
    DB.exec("DELETE FROM category WHERE id = @id;")
  end

  def add_combo(expense_id)
    DB.exec("INSERT INTO expense_categories (category_id, expense_id) VALUES (#{@id}, #{expense_id}) RETURNING id;")
  end

  def total_category_expense
    sum = DB.exec("SELECT sum(e.amount) FROM expenses e INNER JOIN expense_categories ec ON e.id = ec.expense_id INNER JOIN category c ON c.id = ec.category_id WHERE c.id = '#{@id}';")
    sum.first['sum'].to_f
  end

  def percent_spent
   result = self.total_category_expense / Expense.total
   result.round(2) * 100
  end
end
