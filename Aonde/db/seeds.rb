# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	nomes = ["ministerio","tribunal","secretaria"]
	complementos = ["saude","segurança","justica","trabalho"]
	views_amount = (0..9).to_a
	
	10.times do
		name = nomes.sample(1).join+" "+complementos.sample(1).join
		PublicAgency.create(name: name, views_amount: views_amount.sample(3).join.to_i)
	end