class Party < ActiveRecord::Base
  has_many :guest
end
