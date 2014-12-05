require 'test_helper'

class Admin::AiActionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in users(:one)
    @ai_action = ai_actions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ai_actions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ai_action" do
    assert_difference('AiAction.count') do
      post :create, ai_action: { type: @ai_action.type, weight: @ai_action.weight }
    end

    assert_redirected_to admin_ai_action_path(assigns(:ai_action))
  end

  test "should show ai_action" do
    get :show, id: @ai_action
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ai_action
    assert_response :success
  end

  test "should update ai_action" do
    patch :update, id: @ai_action, ai_action: { type: @ai_action.type, weight: @ai_action.weight }
    assert_redirected_to admin_ai_action_path(assigns(:ai_action))
  end

  test "should destroy ai_action" do
    assert_difference('AiAction.count', -1) do
      delete :destroy, id: @ai_action
    end

    assert_redirected_to admin_ai_actions_path
  end
end
