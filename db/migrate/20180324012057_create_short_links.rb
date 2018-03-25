class CreateShortLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :short_links do |t|
      t.string :code
      t.text :url

      t.timestamps

      t.index :code, unique: true
    end
  end
end
