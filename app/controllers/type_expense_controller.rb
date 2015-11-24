# type_expense_controller.rb
# Obtain and process the data of expenses associate to type expense
# of a public agency
class TypeExpenseController < ApplicationController
  
  def show

    find_agencies(params[:id])
    if !params[:year]
      params[:year] = '2015'
    end
    data_type_expense = get_expense_by_type(params[:id], params[:year])
    respond_to do |format|
      format.json { render json: data_type_expense }
    end
    
  end

  def filter_chart

    find_agencies(params[:id])
    @data_type_expense = get_expense_by_type(@public_agency.id,params[:year],params[:month])
    
    #puts "#{@data_type_expense.empty?} #{params[:year]} #{params[:month]}"
    
    @expense_type_find = 0
    if not is_empty_filter(@data_type_expense)
      @expense_type_find = 1
      # Nothing to do
    else
      @data_type_expense = get_expense_by_type(@public_agency.id)
    end

    @data_type_expense = @data_type_expense.to_json

    render 'show'

  end
  
  def get_expense_by_type(id_public_agency, year = '2015')

    all_expenses = HelperController
                  .find_expenses_entity(year,id_public_agency,
                                        :type_expense,:description)

    list_type_expenses = []
    total_expense = 0
    all_expenses.each do |type_expense|
      list_type_expenses << {name: type_expense[0], value: type_expense[1]}
      total_expense += type_expense[1]
      #puts "aqui"
    end
    define_color(total_expense,list_type_expenses)  
    return list_type_expenses
  end

  def find_expenses(id_public_agency = -1, id_type_expense = -1,year = "Todos",month="Todos")
    expenses_find = Expense.where(public_agency_id: id_public_agency,
                       type_expense_id: id_type_expense)
    expense_value = 0
    expenses_find.each do |expense|
      #puts "#{year} #{month} == #{"Todos"} #{"Todos" == month} #{expense.payment_date} "
      if is_date_select(year,month,expense)
        expense_value += expense.value
      end
    end
    return expense_value
  end

  def create_dictionary(value_expense, type_expense)
    expense_dictionary = {}
    if value_expense > 0 
      expense_dictionary = {name: type_expense.description,
                value: value_expense,colorValue: 0}
    else
      # Do nothing
    end
    return expense_dictionary
  end

  def is_date_select(year = "Todos", month = "Todos", expense = nil)
    
    date_select = true
    
    if year != "Todos"
      if ( month_to_int(month) == expense.payment_date.month or
       month == "Todos") and year.to_i == expense.payment_date.year 
        # date select is true
      else
        date_select = false
      end
    else
      # date_select true Will permit sum all expenses
    end

    return date_select
  end

  def is_empty_filter(list_type_expenses=[])
    
    empty_filter = list_type_expenses.empty?
    
    if not empty_filter
      # Do nothing
    else
      flash[:error] = "Nenhuma despesa encontrada no periodo desejado! Veja o gráfico total:"
    end
    return empty_filter
  end

  def define_color(total_expense,list_type_expenses)  
    
    list_type_expenses.each do |expense|
      expense_per_cent = expense[:value]*100/total_expense
      expense[:colorValue] = expense_per_cent.to_i
    end   
  end
end 