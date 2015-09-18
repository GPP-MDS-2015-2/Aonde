class AddColumnsToPublicAgencies < ActiveRecord::Migration
  def change
  	change_table :public_agencies do |t|
  		t.references :superior_public_agency, index: true, foreign_key: true
	    t.string :name
    	t.integer :views_amount
  	end
  end
end
