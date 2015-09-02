class CreateTableA < ActiveRecord::Migration
  def change
    create_table :a do |t|
      t.string :test

      t.timestamps null: false
    end
  end
end
