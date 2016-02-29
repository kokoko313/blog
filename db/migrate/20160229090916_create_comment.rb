class CreateComment < ActiveRecord::Migration
  	def change
  		create_table :comments do |t|
  		t.text :post_id
  		t.text :content
  		t.text :created_date
  		
  		t.timestamps
    	end
	end
end

