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
			program	= program[0]
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
#####################################################################################################	
	def create_nodes(program_id)
		array_validation = [[{"id" => 1,"label" => "Programa1"},{"id"=>2,"label"=>
		 "PublicAgency1"},{"id" => 3,"label" => "Company1"}],[{"from"=>1,"to"=>2},{"from"=>1,"to"=>3}]]
		if program_id != nil
			#Executa a parada 
			return array_validation	
		else
			return [[],[]] 
		end
	end
	def find_entities(program_id, field_entity)
		if field_entity == "public_agency_id"
			return [Expense.new(public_agency_id: 12345)]
		else
			return []
		end
	end
	def add_node(entity,data_program)
		data_program[0] <<"muahahah"
	end
	def add_vertice(data_program)
		data_program[1] << "teste"
	end
end