class ChangeSynopsisTypeToText < ActiveRecord::Migration
  def up
    change_column :movies, :synopsis, :text
  end

  def down
    change_column :movies, :synopsis, :string
  end
end
