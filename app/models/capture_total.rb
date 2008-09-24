class CaptureTotal < ActiveRecord::Base
    belongs_to :species
    belongs_to :country
end
