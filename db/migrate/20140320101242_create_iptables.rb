class CreateIptables < ActiveRecord::Migration
  def change
    create_table :iptables do |t|
      t.string :server_name
      t.column :src_ip, 'integer unsigned'
      t.datetime :time_moment
      t.timestamps
    end
  end
end
