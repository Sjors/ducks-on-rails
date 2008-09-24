class NlVtsAddress < ActiveRecord::Base
    set_primary_keys :KODE
    has_many :ringer_captures
    has_many :ringer_kooikers
end
