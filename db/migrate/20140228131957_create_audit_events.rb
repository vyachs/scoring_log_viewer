class CreateAuditEvents < ActiveRecord::Migration
  def change
    create_table :audit_events do |t|
      t.string :server_name
      t.string :user_name
      t.string :ip
      t.datetime :time_moment
      t.string :kind
      t.timestamps
    end
  end
end
