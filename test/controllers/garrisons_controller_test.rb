require 'test_helper'

class GarrisonsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    sign_in users(:normal_one)
    @garrison = garrisons(:one)
    @for_castle = castles(:one)
  end

  test "should get index for castle" do
    get :index, type:'castles', id:@for_castle.id
    assert_response :success
    assert_not_nil assigns(:garrisons)
  end

  test "should get new for castle" do
    get :new, castle_id: @for_castle.id
    assert_response :success
  end

  test "should create garrison for castle" do
    assert_difference('Garrison.count') do
      post :create, garrison: { garrisonable_id: @garrison.garrisonable_id, garrisonable_type: @garrison.garrisonable_type, kingdom_id: @garrison.kingdom_id, qte: @garrison.qte, soldier_type_id: @garrison.soldier_type_id }
    end

    assert_redirected_to garrison_path(assigns(:garrison))
  end

  test "should show garrison" do
    get :show, id: @garrison
    assert_response :success
  end

  # test "should get edit" do
    # get :edit, id: @garrison
    # assert_response :success
  # end

  # test "should update garrison" do
    # patch :update, id: @garrison, garrison: { garrisonable_id: @garrison.garrisonable_id, garrisonable_type: @garrison.garrisonable_type, kingdom_id: @garrison.kingdom_id, qte: @garrison.qte, soldier_type_id: @garrison.soldier_type_id }
    # assert_redirected_to garrison_path(assigns(:garrison))
  # end

  test "should destroy garrison" do
    assert_difference('Garrison.count', -1) do
      delete :destroy, id: @garrison
    end

    assert_redirected_to garrisons_for_path('castles',@for_castle.id)
  end
end
