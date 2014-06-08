require 'test_helper'
require 'set'

class GuestTest < ActiveSupport::TestCase
  FIXTURE_COUNT = 6
  
  test "fixture is okay" do
    assert_equal FIXTURE_COUNT, Guest.count
    addressees = Guest.select(:email)
    assert_equal FIXTURE_COUNT, addressees.size, "There should be #{FIXTURE_COUNT} records"
    
    cnet_set = Set.new %w{ alantak stacey creidel fritza cornelia orens }
    Guest.select(:email).each { | g |
      cnet_id = g.email.split('@')[0]
      cnet_set.delete cnet_id
    }
    assert_equal 0, cnet_set.count, "The fixture didn't have all the expected cnet ids"
  end

  GOOD_CNET_ID = 'naren'
  test "creating from CNetID" do
    original_count = Guest.count
    
    naren = Guest.new_from_cnetid GOOD_CNET_ID
    assert_not_nil naren, "#{GOOD_CNET_ID} should create a Guest"
    
    assert_equal 'Naren Hazareesingh', naren.name, "Name from #{GOOD_CNET_ID}"
    assert_equal GOOD_CNET_ID + '@uchicago.edu', naren.email, "Email from #{GOOD_CNET_ID}"
    assert_nil naren.party
    refute naren.rsvp
    
    assert naren.save, "#{GOOD_CNET_ID} should be valid for saving"
    assert_equal original_count+1, Guest.count, "Saving #{GOOD_CNET_ID} should add one more guest"
  end
  
  BAD_CNET_ID = 'nonesuch'
  test 'failing to create from a bad CNetID' do
    original_count = Guest.count
    
    stranger = Guest.new_from_cnetid BAD_CNET_ID
    assert_nil stranger, "#{BAD_CNET_ID} should not create a Guest"
    assert_equal original_count, Guest.count, "Failed creation of #{BAD_CNET_ID} should not affect the database."
  end

end
