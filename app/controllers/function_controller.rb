# function_controller.rb
# Process the information of functions only for federation
class FunctionController < ApplicationController

  def show
    dates = HelperController.create_date
    datas = insert_expenses_functions(dates[:begin], dates[:end])
    ordered_data = datas.sort_by { |_description, sumValue| -sumValue }
    @correct_datas = datas.to_json
    @top_10_data = get_top_10_data(ordered_data).to_h.to_json
  end

=begin
  def filter
    datas = control_datas(params[:year], params[:month])
    @correct_datas = datas.to_json
    ordered_data = datas.sort_by { |_description, sumValue| -sumValue }
    @top_10_data = get_top_10_data(ordered_data).to_h.to_json
    render 'show'
  end          
=end

  def filter
    dates = find_dates(params[:year], params[:month])
    expenses = get_expenses(dates)
    @correct_datas = expenses.to_json
    ordered_data = datas.sort_by { |_description, sumValue| -sumValue }
    @top_10_data = get_top_10_data(ordered_data).to_h.to_json
    render 'show'
  end    

  def get_top_10_data(ordered_data)

    @data_not_sort = filter_top_n(ordered_data, 10)
    @top_10_data = sort_by_description(@data_not_sort)

  end

  def sort_by_description(data)

    data.sort_by{ |description, _sumValue| description }

  end

  def filter_top_n(hash, n)
    new_hash = {}

    hash.each_with_index do |(description, sumValue), index|
      break if (index >= n)
      new_hash[description] = sumValue
    end
    new_hash
  end

  def find_dates(year = 'Até hoje!', month = 'Todos')
    dates = {}
    if year == 'Até hoje!'
      dates = HelperController.create_date
    else
      year_filter = year.to_i
      if month == 'Todos'
        date_hash = {from_month: 'Janeiro',end_month: 'Dezembro',from_year: year_filter,end_year: year_filter}
        dates = HelperController.create_date(date_hash)
      else
        date_hash = {from_month: month,end_month: month,from_year: year_filter,end_year: year_filter}
        dates = HelperController.create_date(date_hash)
      end
    end
    dates
  end

  def get_expenses(dates)

    expenses = insert_expenses_functions(dates[:begin], dates[:end]) 

  end

  def insert_expenses_functions(begin_date, end_date)
    expenses = get_expenses_by_function(begin_date, end_date)
    expense_hash = convert_to_a_hash(expenses)
    correct_datas = filter_datas_in_expense(expense_hash)
    correct_datas
  end

  def get_expenses_by_function(begin_date, end_date)
    result = Function.joins(:expense)
             .where('DATE(payment_date) BETWEEN ? AND ?', begin_date, end_date)
             .select('YEAR(payment_date) as date_test, sum(expenses.value) as'\
    ' sumValue,functions.description')
             .group('YEAR(payment_date),functions.description').to_json
    # puts result
    result
  end

  def convert_to_a_hash(expenses)
    expense_hash = JSON.parse(expenses)
  end

  def filter_datas_in_expense(expense_hash)
    correct_hash = {}
    expense_hash.each do |hash|
      function = hash['description']
      correct_hash[function] = hash['sumValue']
    end
    correct_hash
  end
end
