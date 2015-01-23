class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      t.references :question, index: true

      t.timestamps null: false
    end
    # add_foreign_key { k, v} where k_table has v_id as an extra column
    add_foreign_key :answers, :questions  
  end
end
