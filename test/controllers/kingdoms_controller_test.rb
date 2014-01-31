require 'test_helper'

class KingdomsControllerTest < ActionController::TestCase
  setup do
    @kingdom = kingdoms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kingdoms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kingdom" do
    assert_difference('Kingdom.count') do
      post :create, kingdom: { karma: @kingdom.karma, name: @kingdom.name, user_id: @kingdom.user_id }
    end

    assert_redirected_to kingdom_path(assigns(:kingdom))
  end

  test "should show kingdom" do
    get :show, id: @kingdom
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kingdom
    assert_response :success
  end

  test "should update kingdom" do
    patch :update, id: @kingdom, kingdom: { karma: @kingdom.karma, name: @kingdom.name, user_id: @kingdom.user_id }
    assert_redirected_to kingdom_path(assigns(:kingdom))
  end

  test "should destroy kingdom" do
    assert_difference('Kingdom.count', -1) do
      delete :destroy, id: @kingdom
    end

    assert_redirected_to kingdoms_path
  end
end
