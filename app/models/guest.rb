require 'ldap-utils'

class Guest < ActiveRecord::Base
  WEB_SERVICES_GROUP = 'uc:org:nsit:webservices:members'
  
  belongs_to :party
  validates_format_of :email, with: /\w+@\w+\.\w+/
  validates_presence_of :name
  
  def self.new_from_cnetid(cnet_id)
    raise ArgumentError, "CNetID must be a string" unless cnet_id.kind_of? String
    return nil unless LDAPUtils::cnetid_is_in_group cnet_id, WEB_SERVICES_GROUP
    
    record = LDAPUtils::ldap_record_for_cnetid(cnet_id)
    # Oh. Maybe this should not be commented out:
    return nil unless record
    Guest.new name:   record[:displayname][0],
              email:  record[:mail][0]
  end
end
