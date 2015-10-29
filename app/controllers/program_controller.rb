class ProgramController < ApplicationController

  def show
   find_agencies(params[:id])
   @all_programs = find_expenses(@public_agency.id)
   @all_programs.to_json
  end

  def find_expenses(public_agency_id)
   expenses_public_agency = Expense.where(public_agency_id: public_agency_id)
   list_expenses =  find_program(expenses_public_agency).to_a
   return list_expenses
  end


  def find_program(find_expenses_public_agency)
    programs_expense = {}

    find_expenses_public_agency.each do |expense|
                        #PROBLEMA AQUI
      program = Program.where(id: expense.program_id)
      sum_expense_program(program,expense,programs_expense)
      #puts "#{programs_expense}"
    end
    return programs_expense
  end

  def sum_expense_program (program, expense, programs_expense)
    if not program.empty? and program.length == 1
      program = program[0]
      add_expense_program(program, expense, programs_expense)
    else
      #do nothing
      end
  end

  def add_expense_program (program, expense, programs_expense)
    if not programs_expense [program.name]
        programs_expense [program.name] = expense.value
    else
      programs_expense [program.name] += expense.value
    end 
  end
###########################################################3  
  def management_nodes
    find_names(program_id,field_entity)
    add_node(entity,data_program)
    add_edge(data_program)

  end
  def create_nodes(program_id, program_related,field_entity,class_entity)
    begin
      name_entities = find_names(program_id,field_entity)
      name_entities.each do |agency|
        add_node(agency,program_related,class_entity)
        add_edge(program_related)
      end
    rescue Exception => e
      #puts "\n#{e}"
    end
  end
  def find_names(program_id, field_entity,class_entity)
    entities = Expense.select('DISTINCT('+field_entity+')').where(program_id: program_id)
    name_entities = []
    if !entities.nil? && !entities.empty?
      entities.each do |entity|
        correct_id = id_entity(entity,class_entity)
        name_entities << class_entity.find(correct_id).name 
      end
    else
      raise "Entities not found! \n #{program_id} with field #{field_entity}"
    end

    return name_entities 
  end

  def id_entity(entity,class_entity)
    id = 1
    if class_entity == PublicAgency
      id = entity.public_agency_id
    else
      id = entity.company_id
    end
    return id
  end

  def add_node(entity,data_program)
    node = 0
    next_id = data_program[node].last["id"]+1
    data_program[node] << {"id"=>next_id,"label"=>entity}
  end
  def add_edge(data_program)
    node = 0
    last_id = data_program[node].last["id"]
    data_program[1] << {"from"=>1,"to"=>2}
  end
end