class AddFieldsToSuperiorPublicAgency < ActiveRecord::Migration
  def change
  	create_table :superior_public_agencies do |t|

  	  t.string :name
  end
end
