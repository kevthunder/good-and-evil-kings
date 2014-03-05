require 'test_helper'

class MissionStatusesControllerTest < ActionController::TestCase
  setup do
    @mission_status = mission_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mission_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mission_status" do
    assert_difference('MissionStatus.count') do
      post :create, mission_status: { name: @mission_status.name }
    end

    assert_redirected_to mission_status_path(assigns(:mission_status))
  end

  test "should show mission_status" do
    get :show, id: @mission_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mission_status
    assert_response :success
  end

  test "should update mission_status" do
    patch :update, id: @mission_status, mission_status: { name: @mission_status.name }
    assert_redirected_to mission_status_path(assigns(:mission_status))
  end

  test "should destroy mission_status" do
    assert_difference('MissionStatus.count', -1) do
      delete :destroy, id: @mission_status
    end

    assert_redirected_to mission_statuses_path
  end
end
