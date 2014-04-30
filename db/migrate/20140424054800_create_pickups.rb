class CreatePickups < ActiveRecord::Migration
  def change
    create_table :pickups do |t|

      t.timestamps
    end
  end
end
