require 'rubygems'
require 'composite_primary_keys'
class CaptureFormerCountry < ActiveRecord::Base
    set_primary_keys :sch, :ringnr, :occ
    belongs_to :capture, :foreign_key => [:sch, :ringnr, :occ]
    belongs_to :former_country
end

