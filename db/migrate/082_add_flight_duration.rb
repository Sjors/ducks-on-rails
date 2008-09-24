class AddFlightDuration < ActiveRecord::Migration
  def self.up
    add_column :flights, :duration, :integer
    execute "
      UPDATE flights f
      JOIN captures c1 ON f.sch = c1.sch AND f.ringnr = c1.ringnr AND f.occ_start = c1.occ
      JOIN captures c2 ON f.sch = c2.sch AND f.ringnr = c2.ringnr AND f.occ_end = c2.occ
      SET duration = datediff(c2.date,c1.date) 
      WHERE 1
    "
  end

  def self.down
    remove_column :flights, :duration
  end
end
