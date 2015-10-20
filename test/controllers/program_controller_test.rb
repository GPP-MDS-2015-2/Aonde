require 'test_helper'

class ProgramControllerTest < ActionController::TestCase

  def create_programs_expense
    Program.create(name: "ProgramaValido", description: "Programa valido")
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

=begin

  test "teste com parametros" do
    Program.create(id:1)
    get :show ,id: 1
    
    assert :success

    assert assings[:program_expenses]
  end

  test "routas" do
    assert_routes (action: "show",id: 1, )
  end

  def create_programs_expense
    
  end
  
=end

end
