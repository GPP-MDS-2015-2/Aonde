class Program < ActiveRecord::Base

  has_many :expense
  validates :name, presence: true
end
