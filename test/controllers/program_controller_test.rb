require 'test_helper'

class ProgramControllerTest < ActionController::TestCase
  
  def create_programs_expense
    Program.create(name: 'ProgramaValido', description: 'Programa valido')
  end

  test 'Not empty list to find_expenses' do
    generate_program_seed
    not_empty_list = @controller.find_expenses(1)
    assert_not_empty(not_empty_list)
  end
  test 'Size of list find_expenses' do
    generate_program_seed
    expenses_program = @controller.find_expenses(1)
    # the public_agency_id = 1 has 2 programs with expenses

    size_expected = 2
    size_list = expenses_program.size
    assert_equal(size_expected, size_list)
  end
  test 'Not exist id of Public Agency' do
    PublicAgency.create(id: 2, name: 'PublicAgency2', views_amount: 1)
    empty_list = @controller.find_expenses(2)
    assert_empty(empty_list)
  end

  test 'Verify method find_program' do
    generate_program_seed
    expenses = []
    Expense.all.each do |expense|
      if expense.value.nil? || expense.public_agency_id.nil? ||
         expense.program_id.nil?
        # do nothing
      else
        expenses << expense
      end
    end
    expense = @controller.find_program(expenses)
    expense_expected = { 'Programa1' => 12, 'Programa2' => 14 }
    assert_equal(expense_expected, expense)
  end
  test 'empty return to find_program' do
    a = []
    expense_empty = @controller.find_program(a)
    assert_empty(expense_empty)
  end

  
 

  
  test 'Verify method show' do
    generate_program_seed

    assert_routing '/public_agency/1/programs', controller: 'program',
                                                action: 'show', id: '1'
    get :show, id: 1

    assert_response :success

    assert assigns(:public_agency)
    assert assigns(:all_programs)
  end

  test 'create related entities of programs' do
    generate_program_seed
    
    program = Program.new(name:'Programa1',id: 1 )
    graph_nodes = @controller.create_graph_nodes(program, 'public_agency_id',PublicAgency, 1)
    expected_sizes = [2, 1]

    find_sizes = [graph_nodes[0].size, graph_nodes[1].size]

    assert_equal(expected_sizes, find_sizes)
  end

  test 'not include entitie in the association' do
    generate_program_seed

    expected_related = [[{ 'id' => 1, 'label' => 'Programa1' }], []]
    program = Program.new(name: 'Programa1',id: 1)
    program_related = @controller.create_graph_nodes(program, 'company_id', Company,1)

    assert_equal(expected_related, program_related)
  end
  
  test 'return valid public_agency_id' do
    entity = Expense.new(public_agency_id: 3)
    id = @controller.obtain_id(entity, PublicAgency)
    id_expected = 3

    assert_equal(id_expected, id)
  end

  test 'return valid company_id' do
    entity = Expense.new(company_id: 2)
    id = @controller.obtain_id(entity, Company)
    id_expected = 2

    assert_equal(id_expected, id)
  end

  test 'return invalid' do
    entity = Expense.new(company_id: 4)
    id = @controller.obtain_id(entity, Expense)

    assert_nil(id)
  end

  test 'management of nodes' do
    generate_program_seed
    get :show_program, id: 1

    assert_response :success

    assert assigns(:data_program)
    assert assigns(:program)
  end

  test 'route to program' do
    assert_routing 'program/1', controller: 'program', action: 'show_program',
                                id: '1'
  end

  test 'Create data program to public agencies' do 
    generate_program_seed
    process_data = @controller.create_data_program(2,'public_agency_id',PublicAgency)
    expected_data = [['PublicAgency1',14,PublicAgency.name]]
    assert_equal(expected_data,process_data)
  end
  test 'Empty array to not create id of program' do 
    generate_program_seed
    process_data = @controller.create_data_program(3,'public_agency_id',PublicAgency)
    assert_empty(process_data)
  end
  

  def generate_program_seed
    SuperiorPublicAgency.create(id: 1, name: 'SuperiorPublicAgency')
    PublicAgency.create(id: 1, name: 'PublicAgency1', views_amount: 10,
                        superior_public_agency_id: 1)
    name_program = %w(Programa1 Programa2)
    j = 0
    for i in 1..2
      date = Date.new(2015, i, i)
      program = Program.create(id: i, name: name_program[i - 1],
                               description: 'Outros')
      2.times do
        Expense.create(id: j, document_number: i, payment_date: date,
                       value: i + 5, program_id: i, public_agency_id: 1)
        j += 1
      end
    end
    Expense.create(id: 10, document_number: 100,
                   payment_date: Date.new(2015, 1, 1), value: 0, program_id: 1,
                   public_agency_id: 1)
  end

  private :generate_program_seed
end
