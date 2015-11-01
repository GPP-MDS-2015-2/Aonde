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
    program = Program.find(program_id)
    program_related = [[{'id'=>1,'label'=>program.name,'group'=>Program.name}],[]]
    create_nodes(program_id, program_related, "public_agency_id",PublicAgency)
    create_nodes(program_id, program_related, "company_id",Company)
    @data_program = program_related.to_json
  end

  def create_nodes(program_id, program_related, field_entity, class_entity)
    #puts "#{program_related}"
    begin
      name_value_entities = find_names(program_id, field_entity, class_entity)
      #puts name_value_entities
      name_value_entities.each do |agency|
        add_node(agency[0], program_related,class_entity.name)    
        add_edge(program_related,agency[1])
      end
    rescue Exception => e
      puts "\n#{e}"
    end
  end

  def find_names(program_id, field_entity, class_entity)
    entities = Expense.select('DISTINCT(' + field_entity + ')')
               .where(program_id: program_id)
    name_value_entities = []

    if !entities.nil? && !entities.empty?
      add_names_values(program_id, entities, class_entity, field_entity, name_value_entities)
    else
      fail "Entities not found! \n #{program_id} with field #{field_entity}"
    end
    name_value_entities
  end

  def add_names_values(program_id, entities, class_entity, field_entity, name_value_entities)
    entities.each do |entity|
      entity_id = obtain_id(entity, class_entity)
      if !entity_id.nil?
        value = obtain_value(program_id, field_entity, entity_id)
        name = class_entity.find(entity_id).name
        name_value_entities << [name,value]
      end
      
    end
  end
  def obtain_value(program_id, field_entity, entity_id)
    value = Expense.where(program_id: program_id, field_entity => entity_id).sum(:value)
    return value
  end

  def obtain_id(entity, class_entity)
    id = nil
    if class_entity == PublicAgency
      id = entity.public_agency_id
    elsif class_entity == Company
      id = entity.company_id
    else
      id
    end
  end
#Coloquei mais parametros esses dois ultimos
  def add_node(name, data_program,name_entity)
    node = 0
    next_id = data_program[node].last['id'] + 1
    data_program[node] << { 'id' => next_id, 'label' => name ,'group'=> name_entity}
  end

  def add_edge(data_program,value)
    node = 0
    last_id = data_program[node].last['id']
    edge = 1
    value_currency = ActionController::Base.helpers.number_to_currency(value, unit: "R$", separator: ",", delimiter: ".")    
    data_program[edge] << { 'from' => 1, 'to' => last_id ,'value' => value,'title'=> value_currency.to_s,'color'=> 'white'}
  end
end
