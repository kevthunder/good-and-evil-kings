require 'test_helper'

class Admin::NameFragmentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    sign_in users(:admin_one)
    @name_fragment = name_fragments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:name_fragments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create name_fragment" do
    assert_difference('NameFragment.count') do
      post :create, name_fragment: { group: @name_fragment.group, name: @name_fragment.name, pos: @name_fragment.pos }
    end

    assert_redirected_to admin_name_fragment_path(assigns(:name_fragment))
  end

  test "should show name_fragment" do
    get :show, id: @name_fragment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @name_fragment
    assert_response :success
  end

  test "should update name_fragment" do
    patch :update, id: @name_fragment, name_fragment: { group: @name_fragment.group, name: @name_fragment.name, pos: @name_fragment.pos }
    assert_redirected_to admin_name_fragment_path(assigns(:name_fragment))
  end

  test "should destroy name_fragment" do
    assert_difference('NameFragment.count', -1) do
      delete :destroy, id: @name_fragment
    end

    assert_redirected_to admin_name_fragments_path
  end
end
