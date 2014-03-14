class CreatePenetrations < ActiveRecord::Migration
  def change
    create_table :penetrations do |t|
      t.string :server_name
      t.string :vulnerability
      t.string :attacker_ip
      t.string :attacked_ip
      t.datetime :time_moment
      t.timestamps
    end
  end
end
