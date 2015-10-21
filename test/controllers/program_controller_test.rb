require 'test_helper'

class ProgramControllerTest < ActionController::TestCase

  def create_programs_expense
    Program.create(name: "ProgramaValido", description: "Programa valido")
  end

    def generate_expense
     PublicAgency.create(id: 1, name: "PublicAgency1",views_amount: 10)
     name_program = ["Programa1", "Programa2"]
     programs = []
     j = 0
     for i in 1..2
       date = Date.new(2015, i, i)
       program = Program.create(id: i,name: name_program[i-1],
        description: "Outros")
       2.times do
         expense = Expense.new(id: j, document_number: i, payment_date: date,
           value: i + 5,program_id: i,public_agency_id: 1)
         expense.save
         programs << expense
         j+=1
       end
     end
     programs

    end

test "verify find_expenses" do
     generate_expense
     not_empty_list = @controller.find_expenses(1)
     assert_not not_empty_list.empty?

     #the public_agency_id = 1 has 2 programs with expenses
     size_expected = 2

     assert_equal(size_expected, not_empty_list.size)

     PublicAgency.create(id: 2, name:"PublicAgency2",views_amount: 1)
     empty_list = @controller.find_expenses(2)
     assert empty_list.empty?
    end

  test "Verify method find_program" do

       expenses = generate_expense
       expense = @controller.find_program(expenses)
       expense_expected = {"Programa1"=> 12, "Programa2"=>14}
       assert_equal(expense_expected,expense)

       a = []
       expense_empty = @controller.find_program(a)
       assert expense_empty.empty?
  end

  test "Verify the sum of method add_expense_program" do
    
    create_programs_expense

    program = Program.new(id: 1,name: "program test",description: "Program to make a test")
    program2 = Program.new(id: 2, name: "program not test",description: "Program to make a test")
    expense = Expense.new(document_number: "0000", payment_date: Date.new(2015,01,01),value: 100,program_id: 1)
    expense2 = Expense.new(document_number: "0000", payment_date: Date.new(2015,01,01),value: 100,program_id: 2)

  	program_expense = {}

  	@controller.add_expense_program(program, expense, program_expense)
    @controller.add_expense_program(program2, expense2, program_expense)
  	expect_hash = {"program test" => 100,"program not test" => 100}

  	assert_equal( expect_hash, program_expense)

    sum_program_expense = {"program test" => 100}
    @controller.add_expense_program(program,expense,sum_program_expense)
    expect_hash_sum = {"program test" => 200}

    assert_equal(expect_hash_sum,sum_program_expense)





    not_sum_program_expense = {"program test" => 100}

    program_not = Program.new(name: "program test not",description: "Program to make a test")

    @controller.add_expense_program(program_not,expense,not_sum_program_expense)

    not_expect_hash_sum = {"program test" => 200}

    assert_not_equal(not_expect_hash_sum,not_sum_program_expense)

  end

  test "Verify the result of sum_expense_program" do
    program = Program.new(name: "program test",description: "Program to make a test")
    program2 = Program.new(name: "program not test",description: "Program to make a test")
    expense = Expense.new(document_number: "0000", payment_date: Date.new(2015,01,01),value: 100)
    program_expense = {}
    @controller.sum_expense_program([],expense,program_expense)

    assert program_expense.empty?
    
    @controller.sum_expense_program([program,program2],expense,program_expense)

    assert program_expense.empty?

    @controller.sum_expense_program([program],expense,program_expense)

    assert_not program_expense.empty?
  end

  test "Verify method show" do

    generate_expense

    assert_routing '/public_agency/1/programs', { :controller => "program", :action => "show", :id => "1" }  
    get :show, id: 1

    assert_response :success

    assert assigns(:public_agency)
    assert assigns(:all_programs)
  end
end
