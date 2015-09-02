class CreateTableC < ActiveRecord::Migration
  def change
    create_table :c do |t|
      t.string :test

      t.timestamps null: false
    end
  end
end
