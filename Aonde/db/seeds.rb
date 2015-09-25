# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	nomes = ["ministerio","tribunal","secretaria"]
	complementos = ["saude","segurança","justica","trabalho"]
	bolsa = ["saude","remedio","educacao","familia","gasolina","telefone"]
	views_amount = (0..9).to_a
	
	SuperiorPublicAgency.create(name:"Republica Federativa")
	@superior_public_agency = SuperiorPublicAgency.first
	i=0
	10.times do
		print("add the agency #{i}\n")
		name = nomes.sample(1).join+" "+complementos.sample(1).join
		PublicAgency.create(name: name, views_amount: views_amount.sample(3).join.to_i,superior_public_agency_id: @superior_public_agency.id)
		i+=1
	end
i=0
	agencies = PublicAgency.all
	agencies.each do |agency|
		5.times do
			print("add the program #{i} from agency #{agency.id}\n")		
			name = "Bolsa "+ bolsa.sample(1).join
			Program.create(name: name, public_agency_id: agency.id)
			i+=1
		end
	end

	day_month=(1..12).to_a
	programs = Program.all
	i=0
	programs.each do |program|
		5.times do
			print("Add expense #{i} from program #{program.id}\n")
			date = Date.new(2015,day_month[rand(9)],day_month[rand(9)])
			Expense.create(document_number: i,payment_date: date,program_id: program.id,value: day_month[(rand(9))])
			i+=1
		end
	end