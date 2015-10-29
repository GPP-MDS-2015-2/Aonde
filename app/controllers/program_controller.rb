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
  def create_nodes(program_id, program_related,field_entity)
    begin
      agency_list = find_entities(program_id,field_entity)
      agency_list.each do |agency|
        add_node(agency,program_related)
        add_vertice(program_related)
      end
    rescue Exception => e
      puts "\n#{e}"
    end
  end
  def find_entities(program_id, field_entity)
    entities = Expense.select("DISTINCT("+field_entity+")").where(program_id: program_id)
    
    if !entities.nil? && !entities.empty?
      #do nothing
    else
      raise "Entities not found! \n #{program_id} with field #{field_entity}"
    end

    return entities 
  end
  
  def add_node(entity,data_program)
    data_program[0] <<"muahahah"
  end
  def add_vertice(data_program)
    data_program[1] << "teste"
  end
end