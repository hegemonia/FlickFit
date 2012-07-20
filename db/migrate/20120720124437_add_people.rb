class AddPeople < ActiveRecord::Migration
  def change
    create_table(:people) do |t|
      t.string :name
      t.timestamps
    end
    create_table(:movies_directors) do |t|
      t.integer :person_id
      t.integer :movie_id
    end
    create_table(:movies_actors) do |t|
      t.integer :person_id
      t.integer :movie_id
    end
  end
end
