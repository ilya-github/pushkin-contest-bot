class CreateVerses < ActiveRecord::Migration[5.1]
  def change
    create_table :verses do |t|
      t.string :title
      t.text :text
      t.text :text1
      t.text :text2

      t.timestamps
    end
  end
end
