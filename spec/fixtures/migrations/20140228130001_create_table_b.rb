class CreateTableB < ActiveRecord::Migration
  def change
    create_table :b do |t|
      t.string :test

      t.timestamps null: false
    end
  end
end
