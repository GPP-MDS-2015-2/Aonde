require 'test_helper'

class CompanyControllerTest < ActionController::TestCase

	test "Route to method show and the result of the request" do

		generate_public_agency
		assert_routing 'public_agency/1/company', { :controller => "company", :action => "show", :id => "1" }
		get :show, id: 1
		assert_response :success
		assert assigns :array_company_expense

	end

	def generate_public_agency

		SuperiorPublicAgency.create(id: 1,name: "valid SuperiorPublicAgency")
		PublicAgency.create(id: 1,views_amount: 0,name: "valid Agency",superior_public_agency_id: 1)

	end	

	test "should return a ordered hash" do

		hash = {"key1"=>12,"key2"=>8,"key3"=>10}
		hash = @controller.sort_by_expense(hash)
		ordered_hash = {"key2"=>8,"key3"=>10,"key1"=>12}.to_a
		assert_equal(hash,ordered_hash)

	end

	test "should validate an array of companies" do

		company1 = Company.new(id: 1000,name: "company 1")
		company2 = Company.new(id: 1001,name: "company 2")
		
		company_multiples = [company1,company2]

		expense = Expense.new(value: 100,payment_date: Date.new, document_number: '0000')
		hash_companies_multiple = {}
		@controller.test_add_expense(company_multiples,expense,hash_companies_multiple)
		assert hash_companies_multiple.empty?
		
		company_empty = []
		hash_companies_empty = {}
		@controller.test_add_expense(company_empty,expense,hash_companies_empty)
		assert hash_companies_empty.empty?

		company_single = [company1]
		hash_companies_valid = {}
		@controller.test_add_expense(company_single,expense,hash_companies_valid)
		assert_not hash_companies_valid.empty?		

	end

	test "should find a company" do

		expenses = generate_expense
		expense = @controller.find_company(expenses)
		expense_expected = [["CIA",6],["Comercial",15]]
		assert_equal(expense,expense_expected)

		a = []
		expense_empty = @controller.find_company(a)
		assert expense_empty.empty?		

	end	

	test "should return a array with key company name and value expense value" do 

		company_expenses = {"company1"=>1,"company2"=>2,"company3"=>3}
		company_empty = {}
		company = generate_companies

		expense = Expense.create(id: 2,value: 5)

		company_expected = {"company1"=>6,"company2"=>2,"company3"=>3}	
		@controller.testing_companies(company,expense,company_expenses)
		assert_equal(company_expenses,company_expected)

		company_expected2 = {"company1"=>5}
		@controller.testing_companies(company,expense,company_empty)
		assert_equal(company_empty,company_expected2)

	end
	
	def generate_companies

		companies = []
		nome_company = ["company1","company2","company3"]	
		
		i=0
		3.times do
			created_company = Company.create(name: nome_company[i])
			companies[i] = created_company
			i+=1
		end	
		return companies

	end	
	

	def generate_expense

		nome_company = ["CIA","Comercial"]	
		b = []

		i=1
		2.times do
			date = Date.new(2015,i,i)
			company = Company.create(name: nome_company[i-1])
			2.times do
				a = Expense.create(document_number: i,payment_date: date,value: i + 5,company_id: company.id)
				b[i-1] = a
				i+=1
			end
			i -= 1
		end	

		return b

	end




end

