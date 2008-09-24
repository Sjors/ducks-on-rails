class AddPopulateNao < ActiveRecord::Migration

  def self.up
    create_table "nao", :id => false, :force => true do |t|
      t.column "year",          :string, :limit => 100
      t.column "nao", :float
    end
    
    execute 'ALTER TABLE nao ADD PRIMARY KEY (year)'

    print "Insert data from SQL file..."
    if (!system SQL_MIGRATE + "nao.sql") then fail end
  
  end

  def self.down
    drop_table "nao"
  end
end
