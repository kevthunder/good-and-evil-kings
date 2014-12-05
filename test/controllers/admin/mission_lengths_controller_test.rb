require 'test_helper'

class Admin::MissionLengthsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    sign_in users(:one)
    @mission_length = mission_lengths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mission_lengths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mission_length" do
    assert_difference('MissionLength.count') do
      post :create, mission_length: { label: @mission_length.label, reward: @mission_length.reward, seconds: @mission_length.seconds, target_id: @mission_length.target_id, target_type: @mission_length.target_type }
    end

    assert_redirected_to admin_mission_length_path(assigns(:mission_length))
  end

  test "should show mission_length" do
    get :show, id: @mission_length
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mission_length
    assert_response :success
  end

  test "should update mission_length" do
    patch :update, id: @mission_length, mission_length: { label: @mission_length.label, reward: @mission_length.reward, seconds: @mission_length.seconds, target_id: @mission_length.target_id, target_type: @mission_length.target_type }
    assert_redirected_to admin_mission_length_path(assigns(:mission_length))
  end

  test "should destroy mission_length" do
    assert_difference('MissionLength.count', -1) do
      delete :destroy, id: @mission_length
    end

    assert_redirected_to admin_mission_lengths_path
  end
end
