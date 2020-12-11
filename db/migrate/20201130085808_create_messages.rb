class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :user_id
      t.string :sendername
      t.date :createdate
      t.timestamps
    end
  end
end
