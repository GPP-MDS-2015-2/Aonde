require 'test_helper'

class SearchControllerTest < ActionController::TestCase

	test "Should sum value expense of company" do
		create_entities
		id_company = 1
		company_expense = @controller.expense_entities(:company_id,id_company)
		assert_equal(company_expense, 400)
		
	end

	test "Should sum value expense of program" do
		create_entities
		id_program = 1
		program_expense = @controller.expense_entities(:company_id,id_program)
		assert_equal(program_expense, 400)
	end

	test "Should sum value expense of agency" do
		create_entities
		id_public_agency= 1
		agency_expense = @controller.expense_entities(:company_id,id_public_agency)
		assert_equal(agency_expense, 400)
	end

	test "Routes to method idex" do

		create_entities
		
		get :index, id: 1, search: "valid", entity: "Todos"

		assert_response :success

		assert assigns(:entity)
		assert assigns(:msg_error)
		assert assigns(:public_agencies)
		assert assigns(:total_expense_agency)
		assert assigns(:companies)
		assert assigns(:total_expense_company)
		assert assigns(:programs)
		assert assigns(:total_expense_program)
		assert assigns(:results)
		
		
	end

	def create_entities

		PublicAgency.create(id: 1,views_amount: 0,name: "valid Agency")
		Program.create(id: 1,name: "valid Program")
		Company.create(id: 1,name: "valid Company")

		for i in 1..4

			Expense.create(document_number: "0000",payment_date: Date.new(2013,i,1),
							public_agency_id: 1,program_id: 1,company_id: 1,value: 100)

		end	

	end

end