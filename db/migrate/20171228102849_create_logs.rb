class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.text :text

      t.timestamps
    end
  end
end
