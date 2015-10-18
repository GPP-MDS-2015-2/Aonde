require 'test_helper'


class TypeExpenseControllerTest < ActionController::TestCase
		#assert_routing({ path: 'public_agency/:id/expenese_type', method: :get },{ controller: 'type_expense', action: 'get_expense_by_type' })
  test "The calculo of the color based in the porcent in method define_color" do
  	total_expense = 100

  	expense_list = [{value: 20,colorValue: 0},{value: 40,colorValue: 0},
			  		{value: 18,colorValue: 0},{value: 10,colorValue: 0},
			  		{value: 5,colorValue: 0},{value: 2.5,colorValue: 0},
			  		{value: 2.5,colorValue: 0},{value: 1.999,colorValue: 0},
			  		{value: 0.001,colorValue: 0}]
    @controller.define_color(total_expense,expense_list)
       
    expected_list = [{value: 20,colorValue: 20},{value: 40,colorValue: 40},
			  		{value: 18,colorValue: 18},{value: 10,colorValue: 10},
			  		{value: 5,colorValue: 5},{value: 2.5,colorValue: 2},
			  		{value: 2.5,colorValue: 2},{value: 1.999,colorValue: 1},
			  		{value: 0.001,colorValue: 0}]
    assert_equal(expected_list,expense_list,"The two list are different")
	
	expense_list = [{value: 20,colorValue: 0},{value: 40,colorValue: 0},
			  		{value: 18,colorValue: 0},{value: 10,colorValue: 0},
			  		{value: 5,colorValue: 0},{value: 2.5,colorValue: 0},
			  		{value: 2.5,colorValue: 0},{value: 1.999999999999999999999999,colorValue: 0},
				  		{value: 0.001,colorValue: 0}]
	
	@controller.define_color(total_expense,expense_list)

    not_expected_list = [{value: 20,colorValue: 20},{value: 40,colorValue: 40},
			  		{value: 18,colorValue: 18},{value: 10,colorValue: 10},
			  		{value: 5,colorValue: 5},{value: 2.5,colorValue: 2},
			  		{value: 2.5,colorValue: 2},{value: 1.999999999999999999999999,colorValue: 1},
		  			{value: 0.001,colorValue: 0}]
	assert_not_equal(not_expected_list,expense_list,"The list is equals at the not expected")

  end

	test "Verify the list is empty in the method is_empty_filter" do

		list_type_expenses = [{name: "Compra cadeiras",value: 100,colorValue: 50},
								{name: "Compra livros",value: 100,colorValue: 50}]
		not_empty_list = @controller.is_empty_filter(list_type_expenses)
		assert_not (not_empty_list)
		
		list_type_expenses = []
		empty_list = @controller.is_empty_filter(list_type_expenses)
		assert (empty_list)

		no_param = @controller.is_empty_filter()
		assert (no_param)

		#need the begin ... rescue instructions
		#null_type_expenses = nil
		#null_list = @controller.is_empty_filter(null_type_expenses)

	end  

	test "Verify if is_date_select is true" do
		
		
		default_params = @controller.is_date_select
		assert(default_params)
		year = "2014"
		expense_test = Expense.new(payment_date: Date.new(2015,2,20))
		year_params_false = @controller.is_date_select(year,"Todos",
														expense_test)
		
		assert_not(year_params_false)
		
		year_params_true = @controller.is_date_select("2015","Janeiro",
														expense_test)
		assert_not(year_params_true)

		all_month_params = @controller.is_date_select("2015","Todos",
														expense_test)
		assert(all_month_params)
		
		params_validate = @controller.is_date_select("2015","Fevereiro",
														expense_test)
		assert(params_validate)


	end	
end
