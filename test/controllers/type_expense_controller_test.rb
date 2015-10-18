require 'test_helper'


class TypeExpenseControllerTest < ActionController::TestCase
		#assert_routing({ path: 'public_agency/:id/expenese_type', method: :get },{ controller: 'type_expense', action: 'get_expense_by_type' })
	
	test "Sum of the type expenses in method get_expense_by_type" do
		create_entities
		id_public_agency = 1
		expense_type_list = @controller.get_expense_by_type(id_public_agency)
		assert_not expense_type_list.empty?

		expected_list_equal = [{name: "Type expense one valid",value: 500,colorValue: 50},
						{name: "Type expense three valid",value: 500,colorValue: 50}]

		assert_equal(expected_list,expected_list_equal)
 	end

	test "The method find_expenses" do

		public_agency_default = @controller.find_expenses
		expense_value_init = 0
		assert_equal(expense_value_init,public_agency_default)
		
		create_entities
		
		id_public_agency = 1
		type_expense_one = 1
		public_agency = @controller.find_expenses(id_public_agency,type_expense_one)
		assert_equal(public_agency,500)


		type_expense_two = 2
		public_agency_false = @controller.find_expenses(id_public_agency,type_expense_two)
		assert_equal(public_agency_false,0)				

	end

	test "The method create_dictionary" do
		type_expense_equal = TypeExpense.new(description: "teste description")
		value_expense_positive = 100
		positive_expense = @controller.create_dictionary(value_expense_positive,type_expense_equal)
		expect_dictionary_equal = {name: "teste description",value: 100,	colorValue: 0}
		
		assert_equal(expect_dictionary_equal, positive_expense)
		
		expect_dictionary_different = {name: "teste description",value: 101,	colorValue: 0}
		assert_not_equal(expect_dictionary_different, positive_expense)

		value_expense_negative = -1
		negative_expense = @controller.create_dictionary(value_expense_negative,type_expense_equal)
		assert (negative_expense.empty?)

		value_expense_zero = 0

		zero_expense = @controller.create_dictionary(value_expense_negative,type_expense_equal)
		assert (zero_expense.empty?)
	end

	def create_entities
		PublicAgency.create(id: 1,views_amount: 0,name: "valid Agency")
		PublicAgency.create(id: 2,views_amount: 0,name: "valid Agency")

		TypeExpense.create(id: 1, description: "Type expense one valid")
		TypeExpense.create(id: 2, description: "Type expense two invalid")
		TypeExpense.create(id: 3, description: "Type expense three valid")

		Expense.create(document_number: "0000",payment_date: Date.new(2010,1,1),
							public_agency_id: 2,type_expense_id: 2,value: 100)
		for i in 1..5
			Expense.create(document_number: "0000",payment_date: Date.new(2013,i,1),
							public_agency_id: 1,type_expense_id: 1,value: 100)
		end
		for i in 1..5
			Expense.create(document_number: "0000",payment_date: Date.new(2013,i,1),
							public_agency_id: 1,type_expense_id: 3,value: 100)
		end
	end
	
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