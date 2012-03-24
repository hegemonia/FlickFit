class CreateReviews < ActiveRecord::Migration
  def up
  	create_table :reviews do |t|
  		t.integer :rating
  		t.integer :confidence
  		t.references :movie, :user

  		t.timestamps

  	end
		add_index :reviews, [:user_id, :movie_id], :unique => true
  end

  def down
  	drop_table :reviews
  end
end
