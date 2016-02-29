class CreatePosts < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.text :username
  		t.text :content
  		t.text :created_date
  		
  		t.timestamps
    	end
	end
end
