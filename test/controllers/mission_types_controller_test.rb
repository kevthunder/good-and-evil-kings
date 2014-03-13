require 'test_helper'

class MissionTypesControllerTest < ActionController::TestCase
  setup do
    @mission_type = mission_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mission_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mission_type" do
    assert_difference('MissionType.count') do
      post :create, mission_type: { class_name: @mission_type.class_name, name: @mission_type.name }
    end

    assert_redirected_to mission_type_path(assigns(:mission_type))
  end

  test "should show mission_type" do
    get :show, id: @mission_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mission_type
    assert_response :success
  end

  test "should update mission_type" do
    patch :update, id: @mission_type, mission_type: { class_name: @mission_type.class_name, name: @mission_type.name }
    assert_redirected_to mission_type_path(assigns(:mission_type))
  end

  test "should destroy mission_type" do
    assert_difference('MissionType.count', -1) do
      delete :destroy, id: @mission_type
    end

    assert_redirected_to mission_types_path
  end
end
