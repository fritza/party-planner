require 'ActiveTemplate.rb'

class PartyTemplate < ActiveTemplate::Template
  
  make_template do |t|
    
    t.name = "Party"
    
    category "Invitations" do
    end
    
    category "Thanks"
    
  end # make_template
  
end # PartyTemplate

