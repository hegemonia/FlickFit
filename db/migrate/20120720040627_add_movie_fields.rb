class AddMovieFields < ActiveRecord::Migration
  def change
    add_column :movies, :year, :integer
    add_column :movies, :runtime, :integer
    add_column :movies, :synopsis, :string
  end
end
