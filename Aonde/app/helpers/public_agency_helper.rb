module PublicAgencyHelper
	def expenses_public_agency(id_pub_agency)
	  	total_expense = Expense.where(program_id: Program.where(public_agency_id: id_pub_agency).ids).sum(:value)
	  	return total_expense
	end
end	

