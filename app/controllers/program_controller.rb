class ProgramController < ApplicationController

	def show
		find_expenses
	end	
	def find_public_agency
		@public_agency = PublicAgency.find(params[:id])	
	end

	def find_expenses
		find_public_agency
		expenses_public_agency = Expense.where(public_agency_id: @public_agency.id)
		@all_programs = find_program(expenses_public_agency).to_a
		@all_programs.to_json
	end

	def find_program(expenses_public_agency)

		programs_expense = {}

		expenses_public_agency.each do |expense|

			program = Program.where(id: expense.program_id)
			#
			if not program.empty? and program.length == 1
				
				program = program[0]
				if not programs_expense [program.name]
	          		programs_expense [program.name] = expense.value
	        	else
	        		programs_expense[program.name] += expense.value
	        	end

	        end
		end
		return programs_expense
	end
end