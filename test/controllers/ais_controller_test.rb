require 'test_helper'

class AisControllerTest < ActionController::TestCase
  setup do
    @ai = ais(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ais)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ai" do
    assert_difference('Ai.count') do
      post :create, ai: { castle_id: @ai.castle_id, next_action: @ai.next_action }
    end

    assert_redirected_to ai_path(assigns(:ai))
  end

  test "should show ai" do
    get :show, id: @ai
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ai
    assert_response :success
  end

  test "should update ai" do
    patch :update, id: @ai, ai: { castle_id: @ai.castle_id, next_action: @ai.next_action }
    assert_redirected_to ai_path(assigns(:ai))
  end

  test "should destroy ai" do
    assert_difference('Ai.count', -1) do
      delete :destroy, id: @ai
    end

    assert_redirected_to ais_path
  end
end
