class ProgramController < ApplicationController

	def show
		find_public_agency
		find_expenses(@public_agency.id)
	end

	def find_public_agency
		@public_agency = PublicAgency.find(params[:id])	
	end

	def find_expenses(public_agency_id)
		find_public_agency
		expenses_public_agency = Expense.where(public_agency_id: @public_agency.id)
		@all_programs = find_program(expenses_public_agency).to_a
		@all_programs.to_json
	end

	def find_program(find_expenses_public_agency)
		programs_expense = {}

		find_expenses_public_agency.each do |expense|
												#PROBLEMA AQUI
			program = Program.where(id: expense.program_id)
			sum_expense_program(program,expense,programs_expense)
			puts "#{programs_expense}"
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
end