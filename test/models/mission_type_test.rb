require 'test_helper'

class MissionTypeTest < ActiveSupport::TestCase
  test "Exclusion when target and the only castle available are identical" do
    kingdom = kingdoms(:city_state)
    castle = castles(:city_state)
    mission_allow = mission_types(:tax)
    mission_disallow = mission_types(:attack)
    
    assert mission_allow.any_usable_castle_for_target?(castle,kingdom), "Disallowed instead of Allowed"
    assert_not mission_disallow.any_usable_castle_for_target?(castle,kingdom), "Allowed instead of Disallowed"
  end
end
