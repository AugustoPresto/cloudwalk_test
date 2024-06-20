class CreateRepositories < ActiveRecord::Migration[7.1]
  def up
    create_table :repositories do |t|
      t.string :name
      t.integer :stars
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :repositories
  end
end
