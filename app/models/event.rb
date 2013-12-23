class Event < ActiveRecord::Base
	self.table_name = "rideshare_event"

  has_many :rides
end

