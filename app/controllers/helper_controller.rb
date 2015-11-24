# helper_controller.rb
# Contain some method to helper the process of data in controllers
module HelperController
  MONTHNAMES_BR = [nil] + %w(Janeiro Fevereiro Março Abril Maio Junho
                             Julho Agosto Setembro Outubro Novembro Dezembro)
  def self.int_to_month(array)
    
    array.each do |month|
      month[0] = MONTHNAMES_BR[month[0]]
    end
    return array
  end

  def self.sum_expense(key, expense, sum_expeses)
    if !sum_expeses[key]
      sum_expeses[key] = expense.value
    else
      sum_expeses[key] += expense.value
    end
  end

  def self.find_expenses_entity(year = '2015',id,name_entity,attribute)
    begin_year = Date.new(year.to_i,01,01)
    end_year = Date.new(year.to_i,12,31)
    Expense.joins(name_entity)
            .where(public_agency_id: id,payment_date: begin_year..end_year)
            .select(attribute).order('sum_value DESC').group(attribute)
            .sum(:value).to_a

  end

  def self.create_date(date ={from_month: 'Janeiro',end_month: 'Dezembro',
    from_year: 2009,end_year: 2020})
    #puts date
    first_month = month_to_int(date[:from_month])
    last_month = month_to_int(date[:end_month])
    first_date = Date.new(date[:from_year].to_i, first_month, 1)
    last_date = Date.new(date[:end_year].to_i, last_month, 1)

    last_date = last_day_date(last_date)
    date = { begin: first_date, end: last_date }
    # puts date
    date
  end

  def self.month_to_int(month)
    MONTHNAMES_BR.index(month)
  end

  def self.date_valid?(begin_date, end_date)
    valid = true

    if (begin_date.year == end_date.year)
      valid = false if begin_date.month > end_date.month
    elsif begin_date.year > end_date.year
      valid = false
    else
      valid = true
    end
    valid
  end

  def self.last_day_date(date)
    month = date.month

    last_day = 0

    if month == 2
      last_day = leap_year_day(date)
    elsif (month.odd? && month <= 7) || (month.even? && month >= 8)
      last_day = 31
    else
      last_day = 30
    end
    date.change(day: last_day)
  end

  def self.leap_year_day(date)
    day = 0
    if date.leap?
      day = 29
    else
      day = 28
    end
    day
  end
end
