class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :answer, index: true

      t.timestamps null: false
    end
    # add_foreign_key { k, v} where k_table has v_id as an extra column
    add_foreign_key :comments, :answers
  end
end
