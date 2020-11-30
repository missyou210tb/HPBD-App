class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :user_id
      t.integer :user_id_1
      t.timestamps
    end
  end
end
