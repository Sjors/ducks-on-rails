require 'rubygems'
require 'composite_primary_keys'
class Duck < ActiveRecord::Base
    belongs_to :species
    set_primary_keys :sch, :ringnr
    has_many :captures, :foreign_key => [:sch, :ringnr]
    has_one :capture_count, :foreign_key => [:sch, :ringnr]
end

