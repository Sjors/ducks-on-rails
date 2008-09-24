require 'rubygems'
require 'composite_primary_keys'
class Flight < ActiveRecord::Base
    belongs_to :capture, :foreign_key => [:sch, :ringnr, :occ_start]
    belongs_to :capture, :foreign_key => [:sch, :ringnr, :occ_end]
end

