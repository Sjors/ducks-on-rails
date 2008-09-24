require 'rubygems'
require 'composite_primary_keys'
class RingerCapture < ActiveRecord::Base
    has_many :captures, :foreign_key => [:sch, :ringnr, :occ]
    belongs_to :species, :include => [:capture]
    delegate :species, :species=, :to => :capture
    belongs_to :nl_vts_address,  :foreign_key => [:ringer_id]  
    set_primary_keys :ringer_id, :sch, :ringnr, :occ
end
