require 'test_helper'

class SearchControllerTest < ActionController::TestCase

	test "Should sum value expense of company" do
		create_entities
		id_company = 1
		company_expense = @controller.expenses_company(id_company)
		assert_equal(company_expense, 400)
		
	end

	test "Should sum value expense of program" do
		create_entities
		id_program = 1
		program_expense = @controller.expenses_program(id_program)
		assert_equal(program_expense, 400)
	end

	test "Should sum value expense of agency" do
		
	end

	test "" do
		
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