class CreateMovies < ActiveRecord::Migration
  def up
    create_table(:movies) do |t|
    	t.string :title
    	t.timestamps
		end
  end

  def down
  	drop_table(:movies)
  end
end
