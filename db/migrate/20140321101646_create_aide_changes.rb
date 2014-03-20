class CreateAideChanges < ActiveRecord::Migration
  def change
    create_table :aide_changes do |t|
      t.references :report_day
      t.string :file_name
      t.integer :action
      t.timestamps
    end
  end
end
