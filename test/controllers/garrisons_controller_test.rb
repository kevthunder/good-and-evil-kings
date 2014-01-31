require 'test_helper'

class GarrisonsControllerTest < ActionController::TestCase
  setup do
    @garrison = garrisons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:garrisons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create garrison" do
    assert_difference('Garrison.count') do
      post :create, garrison: { garrisonable_id: @garrison.garrisonable_id, garrisonable_type: @garrison.garrisonable_type, kingdom_id: @garrison.kingdom_id, qte: @garrison.qte, soldier_type_id: @garrison.soldier_type_id }
    end

    assert_redirected_to garrison_path(assigns(:garrison))
  end

  test "should show garrison" do
    get :show, id: @garrison
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @garrison
    assert_response :success
  end

  test "should update garrison" do
    patch :update, id: @garrison, garrison: { garrisonable_id: @garrison.garrisonable_id, garrisonable_type: @garrison.garrisonable_type, kingdom_id: @garrison.kingdom_id, qte: @garrison.qte, soldier_type_id: @garrison.soldier_type_id }
    assert_redirected_to garrison_path(assigns(:garrison))
  end

  test "should destroy garrison" do
    assert_difference('Garrison.count', -1) do
      delete :destroy, id: @garrison
    end

    assert_redirected_to garrisons_path
  end
end
