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
	nome_company = ["CIA","Comercial","Depósito","Mercado"]
	complemento_company = ["das bebidas","Marabás","Bersan","do fluxo"]
	views_amount = (0..9).to_a
	funcao_gasto = ["Educação","Saúde","trabalho","Lazer","Moradia"]
	
	SuperiorPublicAgency.create(name:"Republica Federativa")
	@superior_public_agency = SuperiorPublicAgency.first
	i=0
	10.times do
		print("add the agency #{i}\n")
		name = nomes.sample(1).join+" "+complementos.sample(1).join
		PublicAgency.create(name: name, views_amount: 0,
							superior_public_agency_id: @superior_public_agency.id)
		i+=1
	end
	day_month=(1..12).to_a
	
	

	i=1
  j=0
	public_agency = PublicAgency.all
	public_agency.each do |agency|
		4.times do
      j = j+1
			print("Add expense #{i} from public agency #{agency.id}\n")
			date = Date.new(2015,day_month[rand(9)],day_month[rand(9)])
			#name_company = nome_company.sample(1).join+" "+complemento_company.sample(1).join
			company = Company.create(name: "Empresa de teste"+i.to_s)
			function = Function.create(description: "Function"+i.to_s)
			type = TypeExpense.create(description: "TypeExpense"+i.to_s)
			program = Program.create(name: "Program"+i.to_s,description: "Description"+i.to_s)
			4.times do
        j=j+1
				Expense.create(document_number: j,payment_date: date,public_agency_id: agency.id,
					    value: day_month[(rand(9))],company_id: company.id,function_id: function.id,
					    type_expense_id: type.id,program_id: program.id)
				
			end
			i+=1
		end
	end
#rake db:drop
#rake db:create
#rake db:migrate
#rake db:seed
