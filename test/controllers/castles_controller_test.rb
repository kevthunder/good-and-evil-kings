require 'test_helper'

class CastlesControllerTest < ActionController::TestCase
  setup do
    @castle = castles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:castles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create castle" do
    assert_difference('Castle.count') do
      post :create, castle: { elevations_map: @castle.elevations_map, incomes_date: @castle.incomes_date, kingdom_id: @castle.kingdom_id, max_stock: @castle.max_stock, name: @castle.name, pop: @castle.pop }
    end

    assert_redirected_to castle_path(assigns(:castle))
  end

  test "should show castle" do
    get :show, id: @castle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @castle
    assert_response :success
  end

  test "should update castle" do
    patch :update, id: @castle, castle: { elevations_map: @castle.elevations_map, incomes_date: @castle.incomes_date, kingdom_id: @castle.kingdom_id, max_stock: @castle.max_stock, name: @castle.name, pop: @castle.pop }
    assert_redirected_to castle_path(assigns(:castle))
  end

  test "should destroy castle" do
    assert_difference('Castle.count', -1) do
      delete :destroy, id: @castle
    end

    assert_redirected_to castles_path
  end
end
