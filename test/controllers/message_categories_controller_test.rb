require 'test_helper'

class MessageCategoriesControllerTest < ActionController::TestCase
  setup do
    @message_category = message_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_category" do
    assert_difference('MessageCategory.count') do
      post :create, message_category: { title: @message_category.title }
    end

    assert_redirected_to message_category_path(assigns(:message_category))
  end

  test "should show message_category" do
    get :show, id: @message_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message_category
    assert_response :success
  end

  test "should update message_category" do
    patch :update, id: @message_category, message_category: { title: @message_category.title }
    assert_redirected_to message_category_path(assigns(:message_category))
  end

  test "should destroy message_category" do
    assert_difference('MessageCategory.count', -1) do
      delete :destroy, id: @message_category
    end

    assert_redirected_to message_categories_path
  end
end
