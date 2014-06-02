class Party < ActiveRecord::Base
  has_many :guests, dependent: :destroy
  # Change :dependent to :nullify if Party:Guest ever becomes many-to-many
  
  def human_name
    '%s — %s' % [self.theme, self.when_held.strftime("%A, %B %-d")]
  end
end
