class Party < ActiveRecord::Base
  has_many :guests
  
  def human_name
    '%s — %s' % [self.theme, self.when_held.strftime("%A, %B %-d")]
  end
end
