class Company
  attr_reader :name, :id

  def initialize(company_info)
    @name = company_info['name']
    @id = company_info['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM company")
    companies = []
    results.each do |result|
      companies << Company.new(result)
    end
    companies
  end

  def save
    result = DB.exec("INSERT INTO company (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def ==(another)
    self.name == another.name && self.id == another.id
  end

  def set_name(new_name)
    @name = new_name
  end

  def update(attributes)
    attributes.each do |key, value|
      self.send "set_#{key.to_s}", value
    end
  end

  def delete
    DB.exec("DELETE FROM company WHERE id = @id;")
  end

  def total_company_expense
    results = DB.exec("SELECT sum(amount) FROM expenses WHERE company_id = #{@id};")
    sum = results.first['sum'].to_f
    sum.round(2)
  end

  def company_percent_spent
    result = self.total_company_expense / Expense.total
    result.round(2) * 100
  end
end

