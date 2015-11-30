FactoryGirl.define do
  factory :public_agency, class: PublicAgency do
    name "Orgao Publico"
    id 1
    superior_public_agency_id 1
    views_amount 100
  end
end