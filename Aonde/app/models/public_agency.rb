class PublicAgency < ActiveRecord::Base
  belongs_to :superior_public_agency
  has_many :program

#including validation.
  validates :name, presence: true
  validates :views_amount, length: {minimum: 0}
 

PublicAgency.create(name: "Ministerio da Fazenda", views_amount: 10).valid? # => true
PublicAgency.create(name: nil, views_amount: 0).valid? # => false
end
