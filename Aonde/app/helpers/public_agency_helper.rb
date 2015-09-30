module PublicAgencyHelper
	def expenses_public_agency(id_pub_agency)
	  	total_expense = Expense.where(public_agency_id: id_pub_agency).sum(:value)
	  	return total_expense
	end
end	

