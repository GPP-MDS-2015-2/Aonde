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
    name = define_name(program)  
    if !programs_expense [name]
      programs_expense [name] = expense.value
    else
      programs_expense [name] += expense.value
    end
  end

  def define_name(entity)
    name = ''
    if entity.name == Program.name
      name = program.name
    else
      name = entity.class.name+' '+entity.name
    end
    return name
  end
  ###########################################################
  def show_program
    program_id = params[:id].to_i
    @program = Program.find(program_id)
    agency_related = [[{ 'id' => 1, 'label' => @program.name,
                          'group' => Program.name,'fixed'=>true }], []]
    create_nodes(program_id, agency_related, PublicAgency)
    
    company_related = [[{'id'=>agency_related[0].last['id']}],[]]
    create_nodes(program_id, company_related, Company)
    company_related[0].delete_at(0)
    
    program_related = agency_related + company_related
    @data_program = program_related.to_json
  end

  def create_nodes(program_id, program_related, class_entity)
    # puts "#{program_related}"
=begin
    field_entity = define_field(class_entity)
    expenses = Expense.select('DISTINCT ' + field_entity + ', program_id')
               .where(program_id: program_id)
    
    expenses.each do |expense|
      entity_id = obtain_id(expense, class_entity)
      unless entity_id.nil?
        name_value = obtain_name_value(program_id,class_entity,entity_id)
        Graph.create_node( class_entity, program_related, name_value)
      end
    end
=end
    expenses_program = Expense.where(program_id: program_id)
    agency_company ={agency: {},company:{}}
    expenses_program.each do |expense|
      add_name_value(expense)
    end
  end
  def add_name_value(expense,data_program)
    agency = PublicAgency.find(expense.public_agency_id)
    company = Company.find(expense.public_agency_id)
    add_expense_program(agency,expense,data_program[:agency])
    add_expense_program(company,expense,data_program[:company])
  end
  
end
