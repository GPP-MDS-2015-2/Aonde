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

  test 'Verify the sum of method add_expense_program' do
    list_pair = pair_program_expense

    program_expense = {}
    program = 0
    expense = 1

    @controller.add_expense_program(list_pair[program],
                                    list_pair[expense], program_expense)
    expect_hash = { 'program test' => 100 }

    assert_equal(expect_hash, program_expense)
  end

  test 'Add more one program expense to hash' do
    list_pair = pair_program_expense
    sum_program_expense = { 'program test' => 100 }
    program = 0
    expense = 1
    @controller.add_expense_program(list_pair[program],
                                    list_pair[expense], sum_program_expense)
    expect_hash_sum = { 'program test' => 100 }

    assert_not_equal(expect_hash_sum, sum_program_expense)
  end

  test 'Verify the empty result of sum_expense_program' do
    program_expense = {}
    expense = Expense.new(value: 100)
    @controller.sum_expense_program([], expense, program_expense)

    assert_empty(program_expense)
  end
  test 'Verify the not empty result of sum_expense_program' do
    list_program = [Program.new(name: 'Program')]
    expense = Expense.new(value: 100)
    program_expense = {}
    @controller.sum_expense_program(list_program, expense, program_expense)
    assert_not_empty(program_expense)
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
    program_related = [[{ 'id' => 1, 'label' => 'Programa1' }], []]

    @controller.create_nodes(1, program_related, PublicAgency)
    expected_sizes = [2, 1]
    # puts program_related
    find_sizes = [program_related[0].size, program_related[1].size]

    assert_equal(expected_sizes, find_sizes)
  end

  test 'not include entitie in the association' do
    generate_program_seed
    program_related = [[{ 'id' => 1, 'label' => 'Programa1' }], []]

    expected_related = program_related.clone

    @controller.create_nodes(1, program_related, Company)

    assert_equal(expected_related, program_related)
  end

  test 'Add node to array' do
    data_program = [[{ 'id' => 1, 'label' => 'Programa1' }], []]
    company_add = 'company'

    @controller.add_node(company_add, data_program, Company.name)

    data_expected = [[{ 'id' => 1, 'label' => 'Programa1' },
                      { 'id' => 2, 'label' => 'company',
                        'group' => Company.name }], []]

    assert_equal(data_expected, data_program)
  end

  test 'add edge to array' do
    data_program = [[{ 'id' => 1, 'label' => 'Programa1' },
                     { 'id' => 2, 'label' => 'Company1' }], []]
    value = 500
    @controller.add_edge(data_program, value,PublicAgency)

    data_expected = [[{ 'id' => 1, 'label' => 'Programa1' },
                      { 'id' => 2, 'label' => 'Company1' }],
                     [{ 'from' => 1, 'to' => 2, 'value' => 500,
                        'title' => 'R$ 500,00', 'color' => '#43BFC5' }]]

    assert_equal(data_expected, data_program)
  end
  test 'addition of one node' do
    generate_program_seed
    program_related = [[{ 'id' => 1 }], []]

    @controller.create_node(1, PublicAgency, 1, program_related)
    assert_not_empty(program_related[0])
    assert_not_empty(program_related[1])
  end
  test 'empty return to invalid id' do
    program_related = [[], []]
    @controller.create_node(1, PublicAgency, 1, program_related)
    assert_empty(program_related[0])
    assert_empty(program_related[1])
  end

  test 'add names and values' do
    generate_program_seed
    data_expected = { name: 'PublicAgency1', value: 12 }
    name_entities = @controller.obtain_name_value(1, PublicAgency, 1)
    assert_equal(data_expected, name_entities)
  end

  test 'raise erro to no exist agency' do
    assert_raise(Exception) do
      @controller.obtain_name_value(1, PublicAgency, 1)
    end
  end
  
  test 'return color to PublicAgency' do
    
    color_agency = @controller.color_edge(PublicAgency)
    color_expected = '#43BFC5'

    assert_equal(color_expected,color_agency)
  end
  test 'return color to Company' do
    
    color_company = @controller.color_edge(Company)
    color_expected = '#FFBC82'

    assert_equal(color_expected,color_company)
  end
  test 'null result of entity is not Agency or Company' do
    assert_nil(@controller.color_edge(Program))
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

  test 'field of PublicAgency' do
    field_public_agency = 'public_agency_id'
    field_receive = @controller.define_field(PublicAgency)
    assert_equal(field_public_agency, field_receive)
  end
  test 'field of Company' do
    field_company = 'company_id'
    field_receive = @controller.define_field(Company)
    assert_equal(field_company, field_receive)
  end
  test 'null name of other entity' do
    field_receive = @controller.define_field(Program)
    assert_nil(field_receive)
  end

  test 'route to program' do
    assert_routing 'program/1', controller: 'program', action: 'show_program',
                                id: '1'
  end

  private

  def pair_program_expense
    program = Program.new(id: 1, name: 'program test',
                          description: 'Program to make a test')
    expense = Expense.new(document_number: '0000',
                          payment_date: Date.new(2015, 01, 01), value: 100,
                          program_id: 1)
    [program, expense]
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
end
