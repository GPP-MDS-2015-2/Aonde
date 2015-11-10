# helper_controller.rb
# Contain some method to helper the process of data in controllers
module HelperController
  def self.sum_expense(key, expense, sum_expeses)
    if !sum_expeses[key]
      sum_expeses[key] = expense.value
    else
      sum_expeses[key] += expense.value
    end
  end

  def self.create_date(first_year = 2009, last_year = 2016,
   first_month = 01, last_month = 12)
    
    first_date = Date.new(first_year, first_month, 1)
    last_date = Date.new(last_year, last_month, 1)

    last_date = last_day_date(last_date)
    date = {:begin => first_date, :end => last_date}
    #puts date
    return date
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
    return day
  end
end
