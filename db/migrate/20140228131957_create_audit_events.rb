class CreateAuditEvents < ActiveRecord::Migration
  def change
    create_table :audit_events do |t|
      t.string :server_name
      t.string :user_name
      t.string :ip
      t.string :time_moment
      t.string :kind
    end
  end
end
