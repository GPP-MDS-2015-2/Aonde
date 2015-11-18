# program_controller.rb Process de data necessary to respond the requisitions
# of user in the view
class ProgramController < ApplicationController
  def show
    find_agencies(params[:id])
    @all_programs = find_expenses(@public_agency.id)
    @all_programs.to_json
  end

  def find_expenses(public_agency_id)
    expenses_public_agency = Expense.where(public_agency_id: public_agency_id)
                             .select(:program_id, :value)
    list_expenses = find_program(expenses_public_agency).to_a
    list_expenses
  end

  def find_program(find_expenses_public_agency)
    programs_expense = {}

    find_expenses_public_agency.each do |expense|
      # PROBLEMA AQUI
      program = Program.where(id: expense.program_id).select(:name)
      name = program[0].name
      #puts name
      HelperController.sum_expense(name, expense, programs_expense)
      # puts "#{programs_expense}"
    end
    programs_expense
  end

 ###########################################################
  def show_program
    program_id = params[:id].to_i
    @program = Program.find(program_id)

    agency_related = create_graph_nodes(@program, 'public_agency_id',
                                        PublicAgency, 1)
    last_id = agency_related[0].last['id']

    company_related = create_graph_nodes(@program, 'company_id',
                                         Company, last_id)
    company_related[0].delete_at(0)

    program_related = agency_related + company_related
    @data_program = program_related.to_json
  end

  def create_graph_nodes(program, field_entity, class_entity, id_graph)
    entity_related = [[{ 'id' => id_graph, 'label' => program.name }], []]
    begin
      program_agency = create_data_program(program.id, field_entity,
                                           class_entity)
      Graph.create_nodes(program, program_agency, entity_related)
    rescue Exception => error
      #puts "\n#{error}"
    end
    entity_related
  end

  def create_data_program(program_id, field_entity, class_entity)
    select_distinct = Expense.select('DISTINCT(' + field_entity + ')')
                      .where(program_id: program_id)
    name_value = []
    select_distinct.each do |select|
      entity_id = obtain_id(select, class_entity)
      unless entity_id.nil?
        value = Expense.where(program_id: program_id,
                              field_entity => entity_id).sum(:value)
        name = class_entity.find(entity_id).name.strip
        name_value << [name, value, class_entity.name]
      end
    end
    name_value
  end

  def obtain_id(expense, class_entity)
    id = nil
    if class_entity.name == Company.name
      id = expense.company_id
    else
      id = expense.public_agency_id
    end
    id
  end
end
