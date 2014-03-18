require 'test_helper'

class MissionsControllerTest < ActionController::TestCase
  setup do
    @mission = missions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:missions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mission" do
    assert_difference('Mission.count') do
      post :create, mission: { castle_id: @mission.castle_id, mission_status_code: @mission.mission_status_code, next_event: @mission.next_event, target_id: @mission.target_id, target_type: @mission.target_type, type: @mission.type }
    end

    assert_redirected_to mission_path(assigns(:mission))
  end

  test "should show mission" do
    get :show, id: @mission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mission
    assert_response :success
  end

  test "should update mission" do
    patch :update, id: @mission, mission: { castle_id: @mission.castle_id, mission_status_code: @mission.mission_status_code, next_event: @mission.next_event, target_id: @mission.target_id, target_type: @mission.target_type, type: @mission.type }
    assert_redirected_to mission_path(assigns(:mission))
  end

  test "should destroy mission" do
    assert_difference('Mission.count', -1) do
      delete :destroy, id: @mission
    end

    assert_redirected_to missions_path
  end
end
