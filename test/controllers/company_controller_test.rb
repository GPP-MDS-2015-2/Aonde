require 'test_helper'

class CompanyControllerTest < ActionController::TestCase

	test "Route to method show and the result of the request" do

		generate_public_agency
		assert_routing 'public_agency/1/company', { :controller => "company", :action => "show", :id => "1" }
		get :show, id: 1
		assert_response :success

	end

	def generate_public_agency

		PublicAgency.create(id: 1,views_amount: 0,name: "valid Agency")
		
	end	

	test "should return a ordered hash" do

		hash = {"key1"=>12,"key2"=>8,"key3"=>10}
		hash = @controller.sort_by_expense(hash)
		ordered_hash = {"key2"=>8,"key3"=>10,"key1"=>12}.to_a
		assert_equal(hash,ordered_hash)

	end

	test "should validate an array of companies" do

		company = Company.new(id: 1000,name: "company 1")
		company1 = Company.new(id: 1001,name: "company 2")
		
		company_multiples = [company,company1]

		expense = Expense.new(value: 100,payment_date: Date.new, document_number: '0000')
		hash_companies_multiple = {}
		@controller.test_add_expense(company_multiples,expense,hash_companies_multiple)
		assert hash_companies_multiple.empty?
		
		company_empty = []
		hash_companies_empty = {}
		@controller.test_add_expense(company_empty,expense,hash_companies_empty)
		assert hash_companies_empty.empty?

		company_single = [company]
		hash_companies_valid = {}
		@controller.test_add_expense(company_single,expense,hash_companies_valid)
		assert_not hash_companies_valid.empty?		

	end

end

