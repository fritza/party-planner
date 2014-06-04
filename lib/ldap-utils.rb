#! /usr/bin/ruby

# PROBLEM: The TextMate environment isn't finding the net/ldap gem
require 'rubygems'
require 'net-ldap'
=begin
ldap_params = {
   :host =>       'ldap.uchicago.edu',
   :port =>       636,
   :encryption => :simple_tls,
   :auth =>       {:method => :anonymous},
   :base =>       'dc=uchicago,dc=edu'
}

Net::LDAP.open(ldap_params) {
   | ldap |
   
  # filter = Net::LDAP::Filter.eq 'uid', 'wisemen'
   filter = Net::LDAP::Filter.eq 'chicagoid', '21882177X'
   results = ldap.search :filter => filter
   if results && results.size == 1
      puts results.first.inspect
   else
      puts "search resulted in #{results.size} items."
   end
}
=end

module LDAPUtils
   LDAP_PARAMS = {
      :host =>       'ldap.uchicago.edu',
      :port =>       636,
      :encryption => :simple_tls,
      :auth =>       {:method => :anonymous},
      :base =>       'dc=uchicago,dc=edu'
   }
   LDAP_INSTANCE = Net::LDAP.new LDAP_PARAMS
   
   def self.ldap_record_for_chicagoid(chicagoid)
      filter = Net::LDAP::Filter.eq 'chicagoid', chicagoid
      results = LDAP_INSTANCE.search :filter => filter
      if ! results || results.size != 1
         return nil
      else
         return results[0]
      end
   end
   
   def self.ldap_record_for_cnetid(cnetid)
      filter = Net::LDAP::Filter.eq 'uid', cnetid
      results = LDAP_INSTANCE.search :filter => filter
      if ! results || results.size != 1
         return nil
      else
         return results[0]
      end
   end
   
   def self.authenticate_cnetid(cnetid, password)
      record = LDAPUtils::ldap_record_for_cnetid(cnetid)
      ldap = Net::LDAP.new LDAP_PARAMS
      ldap.authenticate(record.dn, password)
      ldap.bind
   end
   # For unit testing, verify that if you fail authenticate_cnetid, 
   # you can still do 
   
   def self.cnetid_is_in_group(cnetid, group)
      record = LDAPUtils::ldap_record_for_cnetid(cnetid)
      return record[:ucismemberof].include?(group)
   end
   
   def self.ldap_record_for_full_name(first, last)
      filter1 = Net::LDAP::Filter.eq 'givenname', first
      filter2 = Net::LDAP::Filter.eq 'sn', last
      results = LDAP_INSTANCE.search :filter => (filter1 & filter2)
      if ! results || results.size != 1
         return nil
      else
         return results[0]
      end
   end
end
