require 'ldap-utils'

class Guest < ActiveRecord::Base
  belongs_to :party
  
  def self.new_from_cnetid(cnet_id)
    raise ArgumentError, "CNetID must be a string" if !(String === cnet_id)
    record = LDAPUtils::ldap_record_for_cnetid(cnet_id)
    Guest.new name:   record[:displayname][0],
              email:  record[:mail][0]
  end
end
