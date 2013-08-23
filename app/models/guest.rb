class Guest < ActiveRecord::Base
  attr_accessible :active_time, :gid, :last_active
end
