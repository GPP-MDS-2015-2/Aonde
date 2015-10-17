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
end
