class AddColumnsToSuperiorPublicAgency < ActiveRecord::Migration
  def change
  	change_table :superior_public_agencies do |t|

  	  t.string :name
    end
  end
end