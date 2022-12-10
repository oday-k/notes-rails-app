class UniqueShare < ActiveRecord::Migration[6.1]
  def change
    add_index :shares, %i[user_id note_id], unique: true
  end
end
