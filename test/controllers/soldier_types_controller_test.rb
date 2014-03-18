require 'test_helper'

class SoldierTypesControllerTest < ActionController::TestCase
  setup do
    @soldier_type = soldier_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:soldier_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create soldier_type" do
    assert_difference('SoldierType.count') do
      post :create, soldier_type: { attack: @soldier_type.attack, carry: @soldier_type.carry, defence: @soldier_type.defence, interception: @soldier_type.interception, name: @soldier_type.name, speed: @soldier_type.speed }
    end

    assert_redirected_to soldier_type_path(assigns(:soldier_type))
  end

  test "should show soldier_type" do
    get :show, id: @soldier_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @soldier_type
    assert_response :success
  end

  test "should update soldier_type" do
    patch :update, id: @soldier_type, soldier_type: { attack: @soldier_type.attack, carry: @soldier_type.carry, defence: @soldier_type.defence, interception: @soldier_type.interception, name: @soldier_type.name, speed: @soldier_type.speed }
    assert_redirected_to soldier_type_path(assigns(:soldier_type))
  end

  test "should destroy soldier_type" do
    assert_difference('SoldierType.count', -1) do
      delete :destroy, id: @soldier_type
    end

    assert_redirected_to soldier_types_path
  end
end
