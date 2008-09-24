class RingerKooiker < ActiveRecord::Base
    belongs_to :nl_vts_address, :foreign_key => [:rid]
    belongs_to :duck_decoy, :foreign_key => [:nearest_decoy_id]
end
