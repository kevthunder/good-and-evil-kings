require 'test_helper'

class MovementTypesControllerTest < ActionController::TestCase
  setup do
    @movement_type = movement_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movement_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movement_type" do
    assert_difference('MovementType.count') do
      post :create, movement_type: { name: @movement_type.name }
    end

    assert_redirected_to movement_type_path(assigns(:movement_type))
  end

  test "should show movement_type" do
    get :show, id: @movement_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movement_type
    assert_response :success
  end

  test "should update movement_type" do
    patch :update, id: @movement_type, movement_type: { name: @movement_type.name }
    assert_redirected_to movement_type_path(assigns(:movement_type))
  end

  test "should destroy movement_type" do
    assert_difference('MovementType.count', -1) do
      delete :destroy, id: @movement_type
    end

    assert_redirected_to movement_types_path
  end
end
