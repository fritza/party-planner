namespace :party do
  
  task :remind => :environment do
    text = File.read 'invite.txt'
    
    how_many_days = ENV['HOW_LONG'] || "10"
    how_many_days = how_many_days.to_i
    parties_after(how_many_days).each do |party|
      party.guests.each do |guest|
        invitation = eval %Q{"#{text}"}
        puts invitation
      end
    end
  end
  
  def parties_after(how_many_days=7)
    date = Date.today + how_many_days
    Party.where('when_held > :future', future: date)
  end
  
end
