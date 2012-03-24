class ChangeRatingToFloat < ActiveRecord::Migration
  def up
  	change_column :reviews, :rating, :float
  end

  def down
  	change_column :reviews, :rating, :integer
  end
end
