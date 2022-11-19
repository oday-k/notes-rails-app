class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :text
      t.timestamps

      t.belongs_to :user
    end
  end
end
