
Dado(/^que eu estou na página do órgão público$/) do
	SuperiorPublicAgency.all.each do |sp|
		puts sp.id
	end
	@superior_public_agency = FactoryGirl.create(:superior_public_agency)
	@public_agency = FactoryGirl.create(:public_agency)

  	visit public_agency_path(@public_agency)
end

Quando(/^eu clico no link do órgão público superior$/) do
  	click_link @superior_public_agency.name 
end

Entao(/^o sistema deve mostrar o grafo do órgão público superior.$/) do
  	visit superior_path(@superior_public_agency)
end
