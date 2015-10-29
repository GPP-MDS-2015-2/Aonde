require 'test_helper'

class ProgramControllerTest < ActionController::TestCase

  def create_programs_expense
    Program.create(name: "ProgramaValido", description: "Programa valido")
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

  test "create related entities of programs" do
    generate_expense
    program_related = [[{"id" => 1,"label" => "Programa1"}],[]]
    
    @controller.create_nodes(1, program_related,"public_agency_id")

    expected_sizes = [3,2]
    puts program_related
    find_sizes = [program_related[0].size,program_related[1].size]

    assert_equal(expected_sizes,find_sizes)
  end

  test "not include entitie in the association" do 
    generate_expense
    program_related = [[{"id" => 1,"label" => "Programa1"}],[]]
    
    expected_related = program_related.clone
    
    @controller.create_nodes(1, program_related,"company_id")

    assert_equal(expected_related , program_related)
  end

  test "methods search public_agency" do
    generate_expense 
    id = 1
    field = "public_agency_id"
    public_agency_list = @controller.find_entities(id,field)
    public_agency_id = public_agency_list[0].public_agency_id
    assert_not_nil(public_agency_id)
  end

  test "methods search company" do
    generate_expense 
    id = 1
    field = "company_id"
    company_list = @controller.find_entities(id,field)
    assert_not_nil(company_list)
  end

  test "exception in search entities" do
    generate_expense
    id = -8
    field = "company_id"
    assert_raise(Exception) do
      company_list = @controller.find_entities(id,field)
    end
  end
  test "Add node to array" do
    data_program = [ [{"id" => 1,"label" => "Programa1"}] ,[]]
    
    company_add = Company.new(id: 2,name: "company to test")
    
    @controller.add_node(company_add,data_program)
    
    new_size = 2
    nodes = 0

    assert_equal(new_size,data_program[nodes].size)
  end

  test "Add vertice to array" do
    data_program = [ [{"id" => 1,"label" => "Programa1"},{"id"=>2,"label"=>"Company1"}] ,[]]
       
    @controller.add_vertice(data_program)
    
    new_size = 1
    vertice = 1

    assert_equal(new_size,data_program[vertice].size)
  end
  
  private
    
    def generate_expense
     SuperiorPublicAgency.create(id:1,name: "SuperiorPublicAgency")
     PublicAgency.create(id: 1, name: "PublicAgency1",views_amount: 10,superior_public_agency_id: 1)
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
end