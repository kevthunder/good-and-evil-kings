require 'test_helper'

class KingdomsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:normal_one)
    @kingdom = kingdoms(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kingdoms)
  end

  test "should get new" do
    sign_in users(:without_kingdom)
    get :new
    assert_response :success
  end

  test "should create kingdom" do
  
    @castle = castles(:one)
    sign_in users(:without_kingdom)
    init = Kingdom.count
    
    post :create, kingdom: { name: @kingdom.name }, castle: { name: @castle.name }
    
    assert_operator( Kingdom.count, :>, init );
    assert_redirected_to castle_path(assigns(:kingdom).current_castle)
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
