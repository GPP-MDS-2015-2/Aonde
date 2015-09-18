class Program < ActiveRecord::Base
  belongs_to :public_agency
  has_many :expense
end
