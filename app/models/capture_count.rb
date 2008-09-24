require 'rubygems'
require 'composite_primary_keys'
class CaptureCount < ActiveRecord::Base
    set_primary_keys :sch, :ringnr
    #has_many :captures, :foreign_key => [:sch, :ringnr]   
    belongs_to :ducks
end

