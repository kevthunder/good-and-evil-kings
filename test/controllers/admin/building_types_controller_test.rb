require 'test_helper'

class Admin::BuildingTypesControllerTest < ActionController::TestCase
  setup do
    @admin_building_type = admin_building_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_building_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_building_type" do
    assert_difference('Admin::BuildingType.count') do
      post :create, admin_building_type: { build_time: @admin_building_type.build_time, name: @admin_building_type.name, predecessor_id: @admin_building_type.predecessor_id, size_x: @admin_building_type.size_x, size_y: @admin_building_type.size_y, type: @admin_building_type.type }
    end

    assert_redirected_to admin_building_type_path(assigns(:admin_building_type))
  end

  test "should show admin_building_type" do
    get :show, id: @admin_building_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_building_type
    assert_response :success
  end

  test "should update admin_building_type" do
    patch :update, id: @admin_building_type, admin_building_type: { build_time: @admin_building_type.build_time, name: @admin_building_type.name, predecessor_id: @admin_building_type.predecessor_id, size_x: @admin_building_type.size_x, size_y: @admin_building_type.size_y, type: @admin_building_type.type }
    assert_redirected_to admin_building_type_path(assigns(:admin_building_type))
  end

  test "should destroy admin_building_type" do
    assert_difference('Admin::BuildingType.count', -1) do
      delete :destroy, id: @admin_building_type
    end

    assert_redirected_to admin_building_types_path
  end
end
