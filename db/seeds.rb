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
	nome_company = ["CIA", "Comercial", "Deposito", "Mercado"]
	complemento_company = ["das bebidas", "Marabás", "Bersan", "do fluxo"]
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
	day_month=(1..12).to_a
	
	i=0
	public_agency = PublicAgency.all
	public_agency.each do |agency|
		10.times do
			print("Add expense #{i} from public agency #{agency.id}\n")
			date = Date.new(2015,day_month[rand(9)],day_month[rand(9)])
			name_company = nome_company.sample(1).join+""+complemento_company.sample(1).join
			company = Company.create(name: name_company)
			Expense.create(document_number: i,payment_date: date,public_agency_id: agency.id,value: day_month[(rand(9))])
			i+=1
		end
	end