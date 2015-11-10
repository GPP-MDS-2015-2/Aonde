# function_controller.rb
# Process the information of functions only for federation
class FunctionController < ApplicationController

  def show
    dates = HelperController.create_date
    datas = insert_expenses_functions(dates[:begin], dates[:end])
    ordered_data = datas.sort_by { |_description, sumValue| -sumValue }
    @correct_datas = datas.to_json
    @top_10_data = filter_top_n(ordered_data, 10)
                   .sort_by { |description, _sumValue| description }
                   .to_h.to_json
    # puts @top_10_data
  end

  def filter
    datas = control_datas(params[:year], params[:month])
    @correct_datas = datas.to_json
    ordered_data = datas.sort_by { |_description, sumValue| -sumValue }
    @top_10_data = filter_top_n(ordered_data, 10)
                   .sort_by { |description, _sumValue| description }
                   .to_h.to_json
    render 'show'
  end

  def filter_top_n(hash, n)
    new_hash = {}

    hash.each_with_index do |(description, sumValue), index|
      break if (index >= n)
      new_hash[description] = sumValue
    end
    new_hash
  end

  def control_datas(year = 'Até hoje!', month = 'Todos')
    dates = {}
    if year == 'Até hoje!'
      dates = HelperController.create_date
    else
      year_filter = year.to_i
      if month == 'Todos'
        dates = HelperController.create_date(year_filter, year_filter)
      else
        dates = HelperController
                .create_date(year_filter, year_filter, month,month)
      end
    end
    #puts dates
    expenses = insert_expenses_functions(dates[:begin], dates[:end])
    #puts expenses
    expenses
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
