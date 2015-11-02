class ProgramController < ApplicationController
  def show
    find_agencies(params[:id])
    @all_programs = find_expenses(@public_agency.id)
    @all_programs.to_json
  end

  def find_expenses(public_agency_id)
    expenses_public_agency = Expense.where(public_agency_id: public_agency_id)
    list_expenses = find_program(expenses_public_agency).to_a
    list_expenses
  end

  def find_program(find_expenses_public_agency)
    programs_expense = {}

    find_expenses_public_agency.each do |expense|
      # PROBLEMA AQUI
      program = Program.where(id: expense.program_id)
      sum_expense_program(program, expense, programs_expense)
      # puts "#{programs_expense}"
    end
    programs_expense
  end

  def sum_expense_program(program, expense, programs_expense)
    if !program.empty? && program.length == 1
      program = program[0]
      add_expense_program(program, expense, programs_expense)
    end
  end

  def add_expense_program(program, expense, programs_expense)
    if !programs_expense [program.name]
      programs_expense [program.name] = expense.value
    else
      programs_expense [program.name] += expense.value
    end
  end

  ###########################################################
  def show_program
    program_id = params[:id]
    program_id = program_id.to_i
    @program = Program.find(program_id)
    program_related = [[{ 'id' => 1, 'label' => @program.name,
                          'group' => Program.name }], []]
    create_nodes(program_id, program_related, PublicAgency)
    create_nodes(program_id, program_related, Company)
    @data_program = program_related.to_json
  end

  def create_nodes(program_id, program_related, class_entity)
    # puts "#{program_related}"
    field_entity = define_field(class_entity)
    expenses = Expense.select('DISTINCT ' + field_entity + ', program_id')
               .where(program_id: program_id)
    expenses.each do |expense|
      entity_id = obtain_id(expense, class_entity)
      unless entity_id.nil?
        create_node(program_id, class_entity, entity_id, program_related)
      end
    end
  end

  def create_node(program_id, class_entity, entity_id, program_related)
    name_value = obtain_name_value(program_id, class_entity, entity_id)

    add_node(name_value[:name], program_related, class_entity.name)
    add_edge(program_related, name_value[:value],class_entity)

  rescue Exception => e
    puts "\n\n\n#{e}\n\n"
  end

  def obtain_name_value(program_id, class_entity, entity_id)
    field_entity = define_field(class_entity)
    name_value = {}
    begin
      value = Expense.where(program_id: program_id,
                            field_entity => entity_id).sum(:value)
      name = class_entity.find(entity_id).name
      name_value = { name: name, value: value }
    rescue Exception => error
      raise "Fail to try obtain expense or name\n#{error}"
    end
    # puts name_value
    name_value
  end

  def add_node(name, data_program, name_entity)
    node = 0
    next_id = data_program[node].last['id'] + 1
    data_program[node] << { 'id' => next_id, 'label' => name,
                            'group' => name_entity }
  end

  def add_edge(data_program, value,class_entity)
    node = 0
    last_id = data_program[node].last['id']
    edge = 1
    currency = ActionController::Base
               .helpers.number_to_currency(
                 value, unit: 'R$', separator: ',', delimiter: '.')
    color = color_edge(class_entity)
    data_program[edge] << { 'from' => 1, 'to' => last_id, 'value' => value,
                            'title' => currency.to_s, 'color' => color}
  end

  def define_field(class_entity)
    field_entity = nil
    if class_entity.name == PublicAgency.name
      field_entity = 'public_agency_id'
    elsif class_entity.name == Company.name
      field_entity = 'company_id'
    else
      field_entity
    end
  end
  def color_edge(class_entity)
    color = nil
    if class_entity.name == PublicAgency.name
      color = '#43BFC5'
    elsif class_entity.name == Company.name
      color = '#FFBC82'
    else
      color
    end
  end
  def obtain_id(expense, class_entity)
    id = nil
    if class_entity.name == PublicAgency.name
      id = expense.public_agency_id
    elsif class_entity.name == Company.name
      id = expense.company_id
      # nothing
    end
  end
end
