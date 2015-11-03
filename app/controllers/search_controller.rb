class SearchController < ApplicationController
	
	def index 
		search = params[:search]
		@entity = params[:entity]
		@msg_error = 1
		if search.tr(' ','').length >= 4
			find_entities
			@results = [1]			
		else
			flash[:error] = "A Pesquisa não pode ter menos que 4 caracteres"
			@msg_error = 0
			@results = []	
		end
	end

	def search_entities(class_entity,name_field,keyword)

		entities = class_entity.where("name LIKE ?", "%#{keyword}%")
		total_expense_entity = {}
		entities.each do |entity|
			total_expense_entity[entity] = expense_entities(name_field,entity.id)
		end
		return total_expense_entity.to_a 
	end
	def find_entities
	 	keyword = params[:search]
	 	@public_agencies = search_entities(PublicAgency,:public_agency_id,keyword)
		@programs = search_entities(Program,:program_id,keyword)
		@companies = search_entities(Company,:company_id,keyword)
	end 

	def expense_entities(name_field,entity_id)
		total_expense = Expense.where(name_field=> entity_id).sum(:value)
	  	return total_expense
	end

end