require 'ActiveTemplate.rb'

class PartyTemplate < ActiveTemplate::Template
  
  make_templates "Party" do |t|
    # If we can get rid of make_templates, so much the better.
    # See if we can do without the t.
        
    category "Invitations" do
      # What would be nice would be to have global mappings, not just category.
      mappings do
        where       :party, :location
        date        :party, :when_held { |when| when.strftime "%A, %B %e, %Y" }
        time        :party, :when_held { |when| when.strftime "%l:%M %p" }
        theme       :party, :theme
        host        :party, :host
        invitee     :invitee
        disinvitee  :disinvitee
      end
      
      template "Invite WS" do        
        # There has to be a way to import foreign strings:
        # In this instance, the invitee (Guest) is not yet in the DB.
        message <<-EOM
Hi %%invitee%%!

We’re having a party on %%date%%, and we’d love to see you there!

It’s at %%where%%, for %%theme%%. %%time%%!

  Hope you can come! 
  -- %%host%%

p.s. Don’t tell %%disinvitee%%
EOM

      template "Invite Stranger" do        
        # There has to be a way to import foreign strings:
        # In this instance, the invitee (Guest) is not yet in the DB.
        # FIXME: This interpolates the strings immediately, right?
        message <<-EOM
Hi %%invitee%%,

Web Services is having a party on %%date%% at %%time%%, for %%theme%%. We hope you can join us at %%where%%

  -- %%host%%
EOM
      end
    end # Invitations
    
    category "Thanks" do
    end # Thanks
    
  end # make_template
  
end # PartyTemplate

