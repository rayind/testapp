class User < ActiveRecord::Base
  attr_accessible :active_time, :last_active, :logins, :password, :username
end
