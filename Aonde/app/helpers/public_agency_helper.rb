module PublicAgencyHelper
	def expenses_public_agency(id_pub_agency)
	  	total_expense = 0
	  	program = Program.where(public_agency_id: id_pub_agency)
	  	program.each do |prog|
	  		expenses = Expense.where(program_id: prog.id)
	  		expenses.each do |exp|
	  			total_expense += exp.value
	  		end	
	  	end
	  	return total_expense
	end
end	

