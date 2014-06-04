#! /usr/bin/ruby

# PROBLEM: The TextMate environment isn't finding the net/ldap gem
require 'rubygems'
require 'net-ldap'

# Utilities to look up persons’ LDAP records by various keys.
#
# The module uses a single instance of <tt>Net::LDAP</tt> initialized for lookups against <tt>ldap.uchicago.edu:636</tt>.
#
# ==== Bugs
#
# - Lookups return +nil+ if there are no results, or more than one. It would be better if there were a way to distinguish them.
module LDAPUtils
  
=begin rdoc
Parameters for queries to +ldap.uchicago.edu+

host::       +ldap.uchicago.edu+
port::       636
encryption:: +simple_tls+
auth::       {method: :anonymous}
base::       <tt>dc=uchicago,dc=edu</tt>
=end
   LDAP_PARAMS = {
      host:       'ldap.uchicago.edu',
      port:       636,
      encryption: :simple_tls,
      auth:       {method: :anonymous},
      base:       'dc=uchicago,dc=edu'
   }
   
   # Shared <tt>Net::LDAP</tt> instance, initialized with parameters for ldap.uchicago.edu
   LDAP_INSTANCE = Net::LDAP.new LDAP_PARAMS
   
   # :category: Lookups
   # Return a <tt>Net::LDAP</tt> record from a ChicagoID, or nil if there is none.
   def self.ldap_record_for_chicagoid(chicagoid)
      filter = Net::LDAP::Filter.eq 'chicagoid', chicagoid
      results = LDAP_INSTANCE.search filter: filter
      if ! results || results.size != 1
         return nil
      else
         return results[0]
      end
   end
   
   # :category: Lookups
   # Return a <tt>Net::LDAP</tt> record from a CNetID, or nil if there is none.
   def self.ldap_record_for_cnetid(cnetid)
      filter = Net::LDAP::Filter.eq 'uid', cnetid
      results = LDAP_INSTANCE.search filter: filter
      if ! results || results.size != 1
         return nil
      else
         return results[0]
      end
   end

   # :category: Authentication
   # Attempt a bind on a CNetID and a password.
   #
   # ==== Returns
   # true:: if the password is correct for the CNetID
   # false:: if not 
   def self.authenticate_cnetid(cnetid, password)
      record = LDAPUtils::ldap_record_for_cnetid(cnetid)
      ldap = Net::LDAP.new LDAP_PARAMS
      ldap.authenticate(record.dn, password)
      ldap.bind
   end
   
   # :category: Authentication
   #
   # Whether the subject's +ucismemberof+ list includes a group, given the CNetID and the name of the group.
   def self.cnetid_is_in_group(cnetid, group)
      record = LDAPUtils::ldap_record_for_cnetid(cnetid)
      return record[:ucismemberof].include?(group)
   end
   
   # :category: Lookups
   # Return a <tt>Net::LDAP</tt> record from the first and last name.
   #
   # first:: Mapped to the +givenname+ field of the record
   # last:: Mapped to the +sn+ field of the record
   #
   # *Caveat:* As with the other <tt>ldap_record_*</tt> methods, +#ldap_record_for_full_name+ returns +nil+ if there is more than one match. This is especially likely in this method.
   def self.ldap_record_for_full_name(first, last)
      filter1 = Net::LDAP::Filter.eq 'givenname', first
      filter2 = Net::LDAP::Filter.eq 'sn', last
      results = LDAP_INSTANCE.search filter: (filter1 & filter2)
      if ! results || results.size != 1
         return nil
      else
         return results[0]
      end
   end
end
