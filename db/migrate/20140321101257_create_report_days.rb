class CreateReportDays < ActiveRecord::Migration
  def change
    create_table :report_days do |t|
      t.datetime :time_moment
      t.string :server_name
      t.integer :total_added, default: 0
      t.integer :total_removed, default: 0
      t.integer :total_changed, default: 0
      t.timestamps
    end
  end
end
