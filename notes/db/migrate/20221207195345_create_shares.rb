class CreateShares < ActiveRecord::Migration[6.1]
  def change
    create_table :shares do |t|
      t.references :user, foreign_key: true
      t.references :note, foreign_key: true
      t.integer :access_level, default: 0
      t.timestamps
    end
  end
end
