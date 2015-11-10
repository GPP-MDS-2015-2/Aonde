# public_agency.rb
# Create a class to handle the data related with public agencies
class PublicAgencyController < ApplicationController
  
  # list of all public agencies in DB
  def index
    @public_agencies = PublicAgency.all
    @total_expense_agency = {}
    @public_agencies.each do |agency|
      @total_expense_agency[agency.id] = expenses_public_agency(agency.id)
    end
  end

  # Find the data of one public agency to show in the view with chart
  def show
    find_agencies(params[:id])
    increment_views_amount
    @list_expense_month = get_expenses_agency(@public_agency.id)
    @list_expense_month.unshift(%w(Data gasto))
  end

  def expenses_public_agency(id_pub_agency)
    total_expense = Expense.where(public_agency_id: id_pub_agency).sum(:value)
    total_expense
  end

  def filter_chart
    # find the same thing then the show
    find_agencies(params[:id])
    begin
      @list_expense_month = create_list_expense(params, @public_agency)
    rescue Exception => error
      flash[:error] = "#{error}\n Veja o gráfico com todos gastos"
      @list_expense_month = get_expenses_agency(public_agency.id)
    end

    # Insert the head in the list
    @list_expense_month.unshift(%w(Data Gasto))
    render 'show'
  end

  def create_list_expense(date, public_agency)
    dates = create_date(date[:from_year], date[:end_year],
                        date[:from_month], date[:end_month])

    list_expense_month = []
    if HelperController.date_valid?(dates[:begin], dates[:end])
      list_expense_month = get_expenses_agency(public_agency.id,
                                               dates[:begin], dates[:end])
    end
    fail 'Não encontrou nenhum gasto no periodo' if list_expense_month.empty?

    list_expense_month
  end

  def get_expenses_agency(id_public_agency,
    _begin_date = '2009-01-01', _end_date = '2020-12-31')

    # Takes all programs and return a list
    # First date of interval

    expenses = Expense.where(public_agency_id: id_public_agency,
                             payment_date: _begin_date.._end_date)

    total_expense_per_date = {}
    expenses.each do |expense|
      date = Date.new(expense.payment_date.year, expense.payment_date.month, 1)
      HelperController.sum_expense(l(date), expense, total_expense_per_date)
    end
    total_expense_per_date.sort_by{ |date,value| value}
  end

  def increment_views_amount
    views_amount = @public_agency.views_amount
    views_amount += 1
    @public_agency.update(views_amount: views_amount)
  end

  # methods that's need to be private
  private :increment_views_amount,
   :get_expenses_agency, :create_list_expense, :expenses_public_agency
  # private :increment_views_amount, :month_to_int
end
